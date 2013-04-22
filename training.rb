require 'rubygems'
require 'sinatra'
require 'sinatra/minify'
require 'yaml'
require 'haml'
require 'rack/contrib'

class Training < Sinatra::Application
  register Sinatra::Minify
  set :public_folder, 'public', File.dirname(__FILE__)
  set :root, 'app', File.dirname(__FILE__)
  set :js_path, 'public/javascripts'
  set :js_url, '/javascripts'

  require_relative 'lib/init'
  require_relative 'app/routes/init'
end
