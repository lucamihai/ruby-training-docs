require 'faraday'
require 'faraday/net_http'
require 'json'

class HttpService
  def initialize
    @connection = Faraday.new do |c|
      c.headers['Authorization'] = "Bearer #{ENV['RUBYGEMS_API_KEY']}"
    end
  end

  def get(uri)
    response = @connection.get(uri)
    exit_if_not_ok(response)
    JSON.parse(response.body)
  end

  private

  def exit_if_not_ok(response)
    if response.status != 200
      puts "Error, got status #{response.status}"
      exit(false)
    end
  end
end
