require './middleware/error_handling_middleware'
require './controllers/authorization_controller.rb'
require './controllers/meme_generator_controller.rb'

#use ErrorHandlingMiddleware

use AuthorizationController
run MemeGeneratorController
