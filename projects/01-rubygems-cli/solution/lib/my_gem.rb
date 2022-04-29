require './lib/jsonable.rb'

class MyGem < JSONable
  
  def initialize(name, info, licenses, downloads)
    @name = name
    @info = info
    @licenses = licenses
    @downloads = downloads
  end

  attr_accessor :name
  attr_accessor :info
  attr_accessor :licenses
  attr_accessor :downloads
end