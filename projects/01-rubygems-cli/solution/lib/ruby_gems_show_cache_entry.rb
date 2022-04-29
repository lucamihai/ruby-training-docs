require './lib/jsonable.rb'

class RubyGemsShowCacheEntry < JSONable
  def initialize(name, time, result)
    @name = name
    @time = time
    @result = result
  end

  attr_accessor :name
  attr_accessor :time
  attr_accessor :result
end