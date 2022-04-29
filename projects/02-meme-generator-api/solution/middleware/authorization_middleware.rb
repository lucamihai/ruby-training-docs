require 'sinatra'
require './lib/my_exception'
require './lib/authorization_handler'

class AuthorizationMiddleware < Sinatra::Base

  use ErrorHandlingMiddleware

  def initialize(app = nil, authorization_handler = AuthorizationHandler.new)
    @app = app
    super(app)

    @authorization_handler = authorization_handler
  end

  def call(env)
    token = env['HTTP_AUTHORIZATION']
    @authorization_handler.authorize(token)
    @app.call(env)
  end

end
