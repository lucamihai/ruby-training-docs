require './lib/user_repository'
require './lib/token_handler'

# Ignore this, just debugging non-sense
token_handler = TokenHandler.new

token = token_handler.generate_token('mihai')
pp token
pp token_handler.is_valid(token)

token2 = token_handler.generate_token('mihai2')
pp token2
pp token_handler.is_valid(token2)