require File.expand_path(File.dirname(__FILE__) + '/training_dashboard')

use Rack::TaticCache, :urls => ["/images"], :root => Dir.pwd + '/public'
run Training.new
