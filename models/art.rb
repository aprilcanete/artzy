require 'sinatra'
require 'sinatra/reloader'
require 'pg'

def db_query(sql, params = [])
    conn = PG.connect(dbname: 'arts_app')
  
    result = conn.exec_params(sql, params)
  
    conn.close
  
    return result
end

def all_arts()

end

def create_art(name, image_url, user_id)
    sql = "insert into arts (name, image_url, user_id) values ($1, $2, $3);"

    db_query(sql, [name, image_url, user_id])
end

def user_arts(user_id)
    sql = "select * from arts where user_id = $1 order by id asc;"

    db_query(sql, [user_id])
end
