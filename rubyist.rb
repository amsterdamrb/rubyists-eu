require 'sinatra'
require 'haml'
require 'openid'
require 'openid/store/filesystem'

set :views, File.join(File.dirname(__FILE__), 'haml')
set :sessions, true

get '/' do
  haml :gmaps
end

get '/login' do
  if session[:openid]
    return 'You are already logged in as '+session[:openid]+', you might want to <a href="/logout">Log Out</a>'
  end

  haml :login
end

post '/login' do
  session[:oid] = OpenID::Consumer.new(
    session,
    OpenID::Store::Filesystem.new( '/tmp/openid' )
  )
  oid_response = session[:oid].begin params['openid_url']
  if oid_response
    redirect oid_response.redirect_url(request.url, request.url + '/complete')
  else
    "failure"
  end
end

get '/login/complete' do
  if session[:openid]
    return 'wat'
  end

  oid_response = session[:oid].complete( params, request.script_name + '/login/complete')
  if session[:openid] = oid_response.identity_url
    'You have successfully logged in as ' + session[:openid]
  else
    'please <a href="/login">Log In</a>'
  end
end

get '/logout' do
  if session[:openid]
    session.delete :openid
    'You have been logged out'
  else
    'You are already logged out'
  end
end

get '/check' do
  if session[:openid]
    "you are logged in"
  else
    "please log in"
  end
end
