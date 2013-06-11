require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require File.join(File.dirname(__FILE__), './drago')

set :environment, :production
disable :run

use Rack::StaticCache, :urls => ["/images"], :root => Dir.pwd + '/public'
run Drago.new
