$LOAD_PATH << File.join(File.dirname(__FILE__), '..')

require 'spec'
require 'rack/test'
require 'spec/interop/test'
require 'application'

Test::Unit::TestCase.send :include, Rack::Test::Methods

set :environment, :test

def app
  Sinatra::Application
end