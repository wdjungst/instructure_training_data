Class Training < Sinatra::Application
 get '/' do
   haml :index
 end
end
