require 'rubygems'
require 'mongoid'
require 'pry'
require File.dirname(__FILE__) + '../../models/mongoid_db'

class Training < Sinatra::Application
  Mongoid.load!("./config/mongoid.yml")
  get '/' do
    haml :index
    binding.pry
  end
end
