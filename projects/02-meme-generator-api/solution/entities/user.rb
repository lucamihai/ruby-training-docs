class User
  @username
  @password

  attr_accessor :username
  attr_accessor :password

  def initialize(username,password)
    @username = username
    @password = password
  end
end
