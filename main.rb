require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'bcrypt'
require 'pry'
require 'cloudinary' # upload media and image

require_relative 'models/art.rb'
require_relative 'models/user.rb'

enable :sessions

options = {
  cloud_name: 'dycwmgta7',
  api_key: '131628642812559',
  api_secret: 'Yr2FxoeZVAQd7RypGYrr-1SEnI8'
}

def logged_in?()
  if session[:user_id]
     true
  else
     false
  end
end

def current_user()
  conn = PG.connect(dbname: 'arts_app')
 
  sql = "select * from users where id = #{session[:user_id]}"

  result = conn.exec(sql)

  user = result[0]

  conn.close

  return OpenStruct.new(user)
end

def active_page?(path='')
  request.path_info == '/' + path
end

get '/' do
  result = all_arts()
  # binding.pry
  # arts = []

  # result.each do |art|
  #   art
  # end
  # return result.to_a

  erb :index, locals: {arts: result}
end

get '/about' do
  erb :about
end

get '/users' do
  erb :login
end

get '/users/new' do
  erb :register
end

post '/users' do
  create_user(params['name'], params['email'], params['password'])

  erb :login
end

post '/users/session' do
  email = params['email']
  password = params['password']

  result = db_query("select * from users where email = $1", [email])

  if result.count > 0 && BCrypt::Password.new(result[0]["password_digest"]) == password
    session[:user_id] = result[0]['id']
    
    redirect '/users/arts'
  else
    redirect '/users?login_fail=true'
  end
end

delete '/users/session' do
  session[:user_id] = nil

  redirect '/users'
end


get '/arts/new' do
  erb :new
end

get '/users/arts' do
  redirect '/users' unless logged_in?

  result = user_arts(current_user.id)

  erb :profile, locals:{arts: result }
end

post '/arts' do
  redirect '/users' unless logged_in?

  file = params['image']['tempfile']

  result =  Cloudinary::Uploader.upload(file, options)

  create_art(params['name'], result["url"], current_user.id)

  redirect '/users/arts'
end

get '/arts/:id' do
  redirect '/users' unless logged_in?

  id = params['id']

  art = db_query("select * from arts where id = $1", [id]).first

  erb :show, locals: {id: id, art: art}
end

get '/arts/:id/edit' do
  redirect '/users' unless logged_in?

  result = db_query("select * from arts where id = $1", [params['id']]).first

  erb :edit, locals: {art: result}
end

put '/arts/:id' do
  file = params['image']['tempfile']

  result =  Cloudinary::Uploader.upload(file, options)

  update_art(params['name'], result["url"], params['id'])

  redirect "/arts/#{params['id']}"
end

delete '/arts/:id' do
  delete_art(params['id'])

  redirect '/users/arts'
end
