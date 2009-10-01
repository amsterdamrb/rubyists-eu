require 'sinatra'
require 'haml'

set :views, File.join(File.dirname(__FILE__), 'haml')

get '/' do
  haml :gmaps
end