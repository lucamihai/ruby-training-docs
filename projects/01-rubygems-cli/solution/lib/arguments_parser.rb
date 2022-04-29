require "./lib/arguments.rb"

module ArgumentsParser
  def self.parse(args)
    arguments = Arguments.new
    arguments.name = get_name(args)
    arguments.search_term = get_search_term(args)
    arguments.search_limit = get_search_limit(args)
    arguments.license = get_license(args)
    arguments.order_by_downloads_descending = get_order_by_downloads_descending(args)

    return arguments
  end

  private

  def self.get_name(args)
    for i in 0..args.count
      if args[i] == 'show'
        return args[i + 1]
      end
    end
    
    return ''
  end

  def self.get_search_term(args)
    for i in 0..args.count
      if args[i] == 'search'
        return args[i + 1]
      end
    end
    
    return ''
  end

  def self.get_search_limit(args)
    for i in 0..args.count
      if args[i] == '--limit'
        return args[i + 1].to_i
      end
    end
    
    return 0
  end

  def self.get_license(args)
    for i in 0..args.count
      if args[i] == '--license'
        return args[i + 1]
      end
    end
    
    return ''
  end

  def self.get_order_by_downloads_descending(args)
    args.find{ |argument| argument == '--most-downloads-first' } != nil
  end

end
