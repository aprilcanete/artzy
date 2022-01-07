require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'bcrypt'


def create_user(name, email, password)
    
    password_digest = BCrypt::Password.create(password)

    sql = "insert into users (name, email, password_digest) values ($1, $2, $3);"

    db_query(sql, [name, email, password_digest])
end