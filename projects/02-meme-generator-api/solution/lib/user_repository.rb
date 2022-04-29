require 'sqlite3'
require './entities/user'
require './lib/my_exception'

class UserRepository
  def initialize()
    @db = SQLite3::Database.new "test.db"
    create_users_table_if_not_existing()
  end

  def add_user(username, password)
    user = User.new(username, password)
    @db.execute("insert into users (username, password) values ('#{username}', '#{password}')")
  end

  def get_user(username)
    result = @db.execute("select * from users where username = '#{username}'")

    if (result.count == 0)
      raise MyException.new('user does not exist', 404)
    end
    
    user_db_row = result[0]
    User.new(user_db_row[0], user_db_row[1])
  end

  def user_exists(username)
    result = @db.execute("select * from users where username = '#{username}'")
    result.count != 0
  end

  private

  def create_users_table_if_not_existing()
    result = @db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users';")

    if (result.count == 0)
      @db.execute("Create table users (username varchar(25), password varchar(100));")
    end
  end
end
