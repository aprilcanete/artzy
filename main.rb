require 'sinatra'
require 'sinatra/reloader'


get '/' do
    erb :index
end


get '/users' do

  erb :login
end

get '/users/new' do
  erb :register
end

post '/users' do

end




