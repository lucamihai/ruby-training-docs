require './lib/ruby_gems_search_cache_entry.rb'
require './lib/ruby_gems_show_cache_entry.rb'
require './lib/my_gem.rb'
require 'time'

class CacheService
  def get_cached_search_result(search_term, last_hours = 48)
    cache_filepath = 'cache_ruby_gems_search.json'

    if (!File.file?(cache_filepath))
      return nil
    end

    cache_ruby_gems_search_file = File.open(cache_filepath)
    json_contents = cache_ruby_gems_search_file.read
    cache_ruby_gems_search_file.close

    json_object = JSON.parse(json_contents)
    cache_entries = json_object.map{ |entry| RubyGemsSearchCacheEntry.new(entry['search_term'], Time.parse(entry['time']), entry['result']) }
    cache_entry = cache_entries.find{ |x| x.search_term == search_term }

    if (cache_entry == nil)
      nil
    elsif (cache_entry.time < get_time_minus_hours(last_hours))
      nil
    else
      cache_entry.result.map{ |hash| MyGem.new(hash['name'], hash['info'], hash['licenses'], hash['downloads']) }
    end
  end

  # TODO: Investigate if appending to the cache file is a better solution (rewriting file vs large file size)
  def cache_search_result(search_term, result)
    if (result.count == 0)
      return
    end

    cache_filepath = 'cache_ruby_gems_search.json'
    json_contents = ''

    if (File.file?(cache_filepath))
      json_contents = File.read(cache_filepath)
    end
    
    cache_ruby_gems_search_file = File.open(cache_filepath, 'w')

    if (json_contents != '')
      json_object = JSON.parse(json_contents)
      cache_entries = json_object.map{ |entry| RubyGemsSearchCacheEntry.new(entry['search_term'], entry['time'], entry['result']) }
      cache_entry = cache_entries.find{ |x| x.search_term == search_term}

      if (cache_entry != nil)
        cache_entry.time = Time.now
        cache_entry.result = result
      else
        new_cache_entry = RubyGemsSearchCacheEntry.new(search_term, Time.now, result)
        cache_entries.push(new_cache_entry)
      end

      cache_ruby_gems_search_file.write(JSON.generate(cache_entries))

    else
      new_cache_entry = RubyGemsSearchCacheEntry.new(search_term, Time.now, result)
      new_json_contents = JSON.generate([new_cache_entry])
      cache_ruby_gems_search_file.write(new_json_contents)
    end
    
    cache_ruby_gems_search_file.close
  end

  def get_cached_show_result(name, last_hours = 48)
    cache_filepath = 'cache_ruby_gems_show.json'

    if (!File.file?(cache_filepath))
      return nil
    end

    cache_file = File.open(cache_filepath)
    json_contents = cache_file.read
    cache_file.close

    json_object = JSON.parse(json_contents)
    cache_entries = json_object.map{ |entry| RubyGemsShowCacheEntry.new(entry['name'], Time.parse(entry['time']), entry['result']) }
    cache_entry = cache_entries.find{ |x| x.name == name }

    if (cache_entry == nil)
      nil
    elsif (cache_entry.time < get_time_minus_hours(last_hours))
      nil
    else
      MyGem.new(cache_entry.result['name'], cache_entry.result['info'], cache_entry.result['licenses'], cache_entry.result['downloads'])
    end
  end

  # TODO: Investigate if appending to the cache file is a better solution (rewriting file vs large file size)
  def cache_show_result(name, result)
    if (result == nil)
      return
    end

    cache_filepath = 'cache_ruby_gems_show.json'
    json_contents = ''

    if (File.file?(cache_filepath))
      json_contents = File.read(cache_filepath)
    end

    cache_file = File.open(cache_filepath, 'w')
    
    if (json_contents != '')
      json_object = JSON.parse(json_contents)
      cache_entries = json_object.map{ |entry| RubyGemsShowCacheEntry.new(entry['name'], entry['time'], entry['result']) }
      cache_entry = cache_entries.find{ |x| x.name == name}

      if (cache_entry != nil)
        cache_entry.time = Time.now
        cache_entry.result = result
      else
        puts 'gotta insert another entry'
        new_cache_entry = RubyGemsShowCacheEntry.new(name, Time.now, result)
        cache_entries.push(new_cache_entry)
      end

      cache_file.write(JSON.generate(cache_entries))

    else
      new_cache_entry = RubyGemsShowCacheEntry.new(name, Time.now, result)
      new_json_contents = JSON.generate([new_cache_entry])
      cache_file.write(new_json_contents)
    end
    
    cache_file.close
  end

  def get_time_minus_hours(hours)
    Time.now - hours * 60 * 60
  end
end