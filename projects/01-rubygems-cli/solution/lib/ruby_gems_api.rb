require './lib/my_gem.rb'
require './lib/http_service'
require './lib/cache_service'
require 'faraday/net_http'
require 'json'
Faraday.default_adapter = :net_http

class RubyGemsApi
  def initialize(http_service = HttpService.new, cache_service = CacheService.new)
    @base_uri = "https://rubygems.org/api"
    @http_service = http_service
    @cache_service = cache_service
  end

  def gem_by_name(name)
    gem_from_cache = @cache_service.get_cached_show_result(name, 48)

    if (gem_from_cache != nil)
      puts "got it from cache"
      return gem_from_cache
    end

    uri = "#{@base_uri}/v1/gems/#{name}"
    json_gem = @http_service.get(uri)
    puts ":( got 'em from ruby gems api"
    
    gem = MyGem.new(json_gem['name'], json_gem['info'], json_gem['licenses'], json_gem['downloads'].to_i)
    @cache_service.cache_show_result(name, gem)
    
    gem
  end

  def search_gems(search_term, search_limit, license, order_by_downloads_descending)
    gems_from_cache = @cache_service.get_cached_search_result(search_term, 48)

    if (gems_from_cache != nil)
      puts "got 'em from cache"
      return filter_gems(gems_from_cache, search_limit, license, order_by_downloads_descending)
    end

    uri = "#{@base_uri}/v1/search?query=#{search_term}"
    json_gems = @http_service.get(uri)

    gems = json_gems.map{ |json_gem| MyGem.new(json_gem['name'], json_gem['info'], json_gem['licenses'], json_gem['downloads'].to_i) }
    @cache_service.cache_search_result(search_term, gems)
    puts ":( got 'em from ruby gems api"

    limit = gems.count > search_limit && search_limit > 0 ? search_limit : gems.count
    filter_gems(gems, search_limit, license, order_by_downloads_descending)
  end

  private

  def filter_gems(gems, search_limit, license, order_by_downloads_descending)
    filtered_gems = license != '' ? gems.filter{ |gem| gem.licenses != nil && gem.licenses.include?(license) } : gems[0..gems.length]
    filtered_gems = order_by_downloads_descending ? filtered_gems.sort_by{ |gem| -gem.downloads } : filtered_gems

    limit = filtered_gems.count > search_limit && search_limit > 0 ? search_limit : filtered_gems.count
    filtered_gems[0..limit - 1]
  end
end
