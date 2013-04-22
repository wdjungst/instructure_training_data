require File.expand_path(File.dirname(__FILE__) + '/training')

use Rack::StaticCache, :urls => ["/images"], :root => Dir.pwd + '/public'
run Training.new
