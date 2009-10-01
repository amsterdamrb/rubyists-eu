app_file = File.join(File.dirname(__FILE__), '..', '..', 'application')

require app_file
require 'spec/expectations'
require 'rack/test'

Sinatra::Application.app_file = app_file

Webrat.configure do |config|
  config.mode = :rack
end

class Application
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  
  Webrat::Methods.delegate_to_session :response_code, :response_body
  
  def app
    Sinatra::Application
  end
end

World {Application.new}