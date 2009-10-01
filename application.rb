require 'sinatra'
require 'haml'
require 'sass'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

get '/' do
  haml :home
end

get '/public/styles/:file' do
  response["Content-Type"] = "text/css; charset=utf-8"
  file = params[:file][0, params[:file].size - 4]
  
  sass file.to_sym, :views => File.join(File.dirname(__FILE__), 'public', 'styles')
end