require './lib/password_handler'
require './lib/user_repository'
require './lib/token_handler'
require './lib/my_exception'

class AuthorizationHandler
  def initialize(
    password_handler = PasswordHandler.new,
    user_repository = UserRepository.new,
    token_handler = TokenHandler.new)

    @password_handler = password_handler
    @user_repository = user_repository
    @token_handler = token_handler
  end

  def signup(username, password)
    validate_credentials(username, password)

    if (@user_repository.user_exists(username))
      raise MyException.new('user already exists', 409)
    end

    encrypted_password = @password_handler.encrypt_password(password)
    @user_repository.add_user(username, encrypted_password)
  end

  def login(username, password)
    validate_credentials(username, password)
    user = @user_repository.get_user(username)
    
    if (!@password_handler.is_same_password(password, user.password))
      raise MyException.new('incorrect password', 401)
    end

    @token_handler.generate_token(username)
  end

  def authorize(token)
    if (!@token_handler.is_valid(token))
      raise MyException.new('invalid token', 401)
    end
  end

  private

  def validate_credentials(username, password)
    if (username == nil || username == '')
      raise MyException.new('username must not be empty', 400)
    end

    if (password == nil || password == '')
      raise MyException.new('password must not be empty', 400)
    end
  end
end
