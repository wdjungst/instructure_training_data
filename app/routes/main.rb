require 'rubygems'
require 'pry'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'mysql',
  :host => 'localhost',
  :encoding => 'utf8',
  :database => 'training',
  :username => 'root',
  :password => 'password'
)

class Participant < ActiveRecord::Base
end

class Training < Sinatra::Application
  get '/' do
    haml :index
    binding.pry
  end
end
