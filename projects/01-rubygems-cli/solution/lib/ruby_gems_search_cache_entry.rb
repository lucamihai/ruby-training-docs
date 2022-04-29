require './lib/jsonable.rb'

class RubyGemsSearchCacheEntry < JSONable

  def initialize(search_term, time, result)
    @search_term = search_term
    @time = time
    @result = result
  end

  attr_accessor :search_term
  attr_accessor :time
  attr_accessor :result
end