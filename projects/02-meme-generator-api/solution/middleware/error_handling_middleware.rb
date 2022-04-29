require 'sinatra'
require './lib/my_exception'

class ErrorHandlingMiddleware < Sinatra::Base

  def initialize(app = nil)
    @app = app
    super(app)
  end

  configure do
    set :show_exceptions, :after_handler
  end

  error MyException do
    my_exception = env['sinatra.error']
    [my_exception.http_code, my_exception.message]
  end

end
