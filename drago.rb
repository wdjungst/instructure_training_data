require 'rubygems'
require 'sinatra'
require 'sinatra/minify'
require 'yaml'
require 'haml'
require 'rack/contrib'
require File.expand_path(File.dirname(__FILE__) + '/config/database')

class Drago < Sinatra::Application
  register Sinatra::Minify
  set :protection, except: :frame_options
  set :public_folder, 'public', File.dirname(__FILE__)
  set :root, 'app', File.dirname(__FILE__)
  set :js_path, 'public/javascripts'
  set :js_url, '/javascripts'
  set :enviornment, :production

  require_relative 'app/routes/init'
end
