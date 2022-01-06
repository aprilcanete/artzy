require 'sinatra/base' 

class HelloWorld < Sinatra::Base
  get '/' do
    erb :index
  end
end





