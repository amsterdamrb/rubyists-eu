require 'sinatra'
require 'haml'

set :views, File.join(File.dirname(__FILE__), 'haml')

get '/' do
  template('gmaps').render
end

def template(name)
  Haml::Engine.new(File.read(File.join(File.dirname(__FILE__),'haml',"#{name}.haml")))
end