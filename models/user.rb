ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'sample.db')

class User < ActiveRecord::Base

end