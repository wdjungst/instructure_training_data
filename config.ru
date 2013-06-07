require 'sinatra'
require File.expand_path(File.dirname(__FILE__) + '/training')

set :environment, :production
disable :run

require File.join(File.dirname(__FILE__), 'drago')

use Rack::StaticCache, :urls => ["/images"], :root => Dir.pwd + '/public'
run Sinatra::Application
