require 'json'
require 'sinatra'
require './lib/request_body_parser'
require './lib/meme_generator'
require './middleware/authorization_middleware'

class MemeGeneratorController < Sinatra::Base

  use AuthorizationMiddleware
  use ErrorHandlingMiddleware

  post '/memes' do
    meme_arguments = RequestBodyParser.extract_meme_arguments(request.body.read)

    meme_absolute_file_path = MemeGenerator.generate_meme(meme_arguments)
    
    send_file("#{meme_absolute_file_path}")
  end
end
