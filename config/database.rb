require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'mysql',
  :host => 'localhost',
  :encoding => 'utf8',
  :database => 'training',
  :username => 'root',
  :password => 'password'
)
