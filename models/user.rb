require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'bcrypt'


def create_user(name, email, password)
    
    password_digest = BCrypt::Password.create(password)

    sql = "insert into users (name, email, password_digest) values ($1, $2, $3);"

    db_query(sql, [name, email, password_digest])
end

def get_username(user_id)
    result = db_query("select name from users where id = $1;", [user_id])

    result.first['name']
end