desc "Builds the minified CSS and JS assets"
task :minify do
  require './training.rb'
  puts "Building..."

  files = Sinatra::Minify::Package.build(Training)
  files.each { |f| puts " * #{File.basename f}" }
  puts "Construction complete!"
end

