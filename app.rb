require 'sinatra'
require 'sinatra/reloader' # ファイルに変更を加えた際にサーバーの再起動が必要ない
require 'sqlite3'
require 'sinatra/activerecord' # 追加
require './models/user.rb' # 追加

get '/' do
    'hello world!'
end

get '/html' do
    '<h1>hello world!</h1>'
end

get '/html-completed' do
    '<html><head></head><body><h1>hello world!</h1></body></html>'
end

get '/html-completed-erb' do
    erb :html_completed
end

get '/learn-layout' do
    erb :learn_layout
end

get '/users' do
    db = SQLite3::Database.new 'sample.db'
    @rs = db.execute('select * from users;') # @rs = [ [1, "taro"], [2, "jiro"], [3, "saburo"], [4, "佐藤"] ]
    # p rs
    @users_hash = @rs.map do |row|
        { id: row[0], name: row[1] } # [ {:id=>1, :name=>"taro"}, {:id=>2, :name=>"jiro"}, {:id=>3, :name=>"saburo"}, {:id=>4, :name=>"佐藤"} ]
    end
    erb :'users/index'
end

get '/users/new' do # 新規作成画面の表示
    erb :'users/new'
end

post '/users' do # フォームからデータが送信された
    db = SQLite3::Database.new 'sample.db'
    sql = 'insert into users(name) values(?);'
    stmt = db.prepare(sql)
    stmt.bind_params(params[:name])
    stmt.execute

    redirect to('/users')
end

get '/ar/users' do
    @users = User.all # [ {:id=>1, :name=>"taro"}, {:id=>2, :name=>"jiro"}, {:id=>3, :name=>"saburo"}, {:id=>4, :name=>"佐藤"} ]
    erb :'ar/users/index'
end

get '/ar/users/new' do
    erb :'ar/users/new'
end

post '/ar/users' do
    User.create(name: params[:name])
    redirect to('/ar/users')
end