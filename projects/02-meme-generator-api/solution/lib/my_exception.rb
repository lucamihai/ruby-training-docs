class MyException < StandardError
  @message
  @http_code

  attr_accessor :message
  attr_accessor :http_code

  def initialize(message = "Unknown error (or the programmer was too lazy to provide an actual useful message)", http_code = 500)
    @message = message
    @http_code = http_code
  end
end
