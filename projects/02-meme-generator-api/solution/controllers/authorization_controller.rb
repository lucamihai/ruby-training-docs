require 'json'
require 'sinatra'
require './lib/request_body_parser'
require './lib/authorization_handler'

class AuthorizationController < Sinatra::Base
  
  use ErrorHandlingMiddleware

  def initialize(app = nil, authorization_handler = AuthorizationHandler.new)
    super(app)
    @authorization_handler = authorization_handler
  end

  post '/auth/signup' do
    signup_arguments = RequestBodyParser.extract_signup_arguments(request.body.read)
    @authorization_handler.signup(signup_arguments.username, signup_arguments.password)
  end

  post '/auth/login' do
    login_arguments = RequestBodyParser.extract_login_arguments(request.body.read)
    @authorization_handler.login(login_arguments.username, login_arguments.password)
  end

end
