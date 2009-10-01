require 'sinatra'
require 'haml'
require 'openid'
require 'openid/store/filesystem'

set :views, File.join(File.dirname(__FILE__), 'haml')

get '/' do
  haml :gmaps
end

get '/login' do
  haml :login
end

get '/login/complete' do
  "completed"
end

post '/login' do
  oid = OpenID::Consumer.new(
    session,
    OpenID::Store::Filesystem.new( '/tmp/openid' )
  )
  oid_response = oid.begin params['openid_url']
  if oid_response
    redirect oid_response.redirect_url('http://localhost:9393/', 'http://localhost:9393/login/complete')
  else
    "failure"
  end
end
