$LOAD_PATH << File.join(File.dirname(__FILE__), '..')

require 'application'
require 'spec'
require 'rack/test'
require 'spec/interop/test'

Test::Unit::TestCase.send :include, Rack::Test::Methods

set :environment, :test

def app
  Sinatra::Application
end

PATTERN_COUNTRY_CODE = /^[A-Z]{2}$/
PATTERN_EMAIL = /^(?:[a-z]+)(\.[\w\-]+)*@([\w\-]+)(\.[\w\-\.]+)*(\.[a-z]{2,4})$/i
PATTERN_NAME = /^([A-Z][a-z\.\-]*\s?)+$/
