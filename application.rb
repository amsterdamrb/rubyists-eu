require 'sinatra'
require 'haml'
require 'sass'
require 'openid'
require 'openid/store/filesystem'
require 'dm-core'
require 'dm-aggregates'
require 'json'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  set :sessions, true
end

DataMapper.setup(:default, (ENV['DATABASE_URL'] || "postgres://postgres@localhost/rubyists"))

class Member
  include DataMapper::Resource

  property :id, Serial
  property :openid, String
  property :name, String
  property :city, String
  property :country, String

  def self.seed
    return if count > 0
    member = new

    member.openid = "Hola"
    member.name = "Javier Cicchelli"
    member.city = "Buenos Aires"
    member.country = "Argentina"

    member.save
  end
end

class UserGroup
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :city, String
  property :country, String

  def self.seed
    {
      'Amsterdam.rb' => {:city => 'Amsterdam', :country => 'The Netherlands'},
      'Utrecht.rb' => {:city => 'Utrecht', :country => 'The Netherlands'},
      'Den Haag.rb' => {:city => 'Den Haag', :country => 'The Netherlands'},
    }.each do |name, attrs|
      next if count(:name => name) > 0
      ug = new

      ug.name = name
      ug.city = attrs[:city]
      ug.country = attrs[:country]

      ug.save
    end
  end

  def to_json
    attributes.to_json
  end
end

class DataMapper::Collection
  def to_json
    to_a.to_json
  end
end

DataMapper.auto_migrate!
Member.seed
UserGroup.seed

get '/' do
  haml :home
end

get '/styles/:file' do
  response["Content-Type"] = "text/css; charset=utf-8"
  file = params[:file][0, params[:file].size - 4]

  sass file.to_sym, :views => File.join(File.dirname(__FILE__), 'public', 'styles')
end

get '/ajax/user_groups.js' do
  user_groups = UserGroup.all
  user_groups.to_json
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
    return 'You are not logged in, your OpenID login failed or you refused to login'
  end

  if session[:openid_identity] = oid_response.identity_url
    session.delete :openid_consumer
    'You have successfully logged in as ' + session[:openid_identity]
    redirect '/' # XXX
  else
    'please <a href="/login">Log In</a>'
  end
end

get '/logout' do
  if session[:openid_identity]
    session.delete :openid_identity
    'You have been logged out'
    redirect '/' # XXX
  else
    'You were already logged out'
  end
end

get '/check' do
  if session[:openid_identity]
    "you are logged in"
  else
    "please log in"
  end
end
