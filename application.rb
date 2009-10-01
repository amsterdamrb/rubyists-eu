require 'sinatra'
require 'haml'
require 'sass'
require 'openid'
require 'openid/store/filesystem'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  set :sessions, true
end

get '/' do
  haml :home
end

get '/styles/:file' do
  response["Content-Type"] = "text/css; charset=utf-8"
  file = params[:file][0, params[:file].size - 4]
  
  sass file.to_sym, :views => File.join(File.dirname(__FILE__), 'public', 'styles')
end

get '/login' do
  if session[:openid_identity]
    return 'You are already logged in as '+session[:openid_identity]+', you might want to <a href="/logout">Log Out</a>'
  end

  haml :login
end

post '/login' do
  session[:openid_consumer] = OpenID::Consumer.new(
    session,
    OpenID::Store::Filesystem.new( '/tmp/openid' )
  )
  oid_response = session[:openid_consumer].begin params['openid_url']
  if oid_response
    redirect oid_response.redirect_url(request.url, request.url + '/complete')
  else
    "failure"
  end
end

get '/login/complete' do
  if session[:openid_identity]
    return 'wat'
  end

  oid_response = session[:openid_consumer].complete( params, request.url )
  if oid_response.status != :success
    return 'you are doing something wrong'
  end

  if session[:openid_identity] = oid_response.identity_url
    session.delete :openid_consumer
    'You have successfully logged in as ' + session[:openid_identity]
  else
    'please <a href="/login">Log In</a>'
  end
end

get '/logout' do
  if session[:openid_identity]
    session.delete :openid_identity
    'You have been logged out'
  else
    'You are already logged out'
  end
end

get '/check' do
  if session[:openid_identity]
    "you are logged in"
  else
    "please log in"
  end
end
