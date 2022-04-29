require 'jwt'
require './lib/user_repository'

class TokenHandler
  def initialize(user_repository = UserRepository.new)
    @user_repository = user_repository
  end

  def generate_token(username)
    payload = { username: username }

    # I know, not very secure
    token = JWT.encode(payload, nil, 'none')
  end

  def is_valid(token)
    if (token == nil || token == '')
      return false
    end

    # I know, not very secure
    decoded_token = JWT.decode(token, nil, false)
    username = decoded_token[0]['username']
    @user_repository.user_exists(username)
  end
end
