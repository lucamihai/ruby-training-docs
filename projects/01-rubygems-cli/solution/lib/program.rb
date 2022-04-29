require './lib/arguments_parser.rb'
require './lib/ruby_gems_api.rb'

class Program

  def initialize(ruby_gems_api = RubyGemsApi.new)
    @ruby_gems_api = ruby_gems_api
  end

  def execute(args)
    arguments = ArgumentsParser.parse(args)

    if (arguments.name != '')
      gem = @ruby_gems_api.gem_by_name(arguments.name)
      display_gem(gem)
      puts "---------------------------------\n"
    end

    if (arguments.search_term != '')
      gems = @ruby_gems_api.search_gems(arguments.search_term, arguments.search_limit, arguments.license, arguments.order_by_downloads_descending)
      display_gems(gems)
    end
  end

  private

  def display_gem(gem)
    puts "---------------------------------\n"
    info = gem.info.length > 100 ? "#{gem.info[0, 100]}..." : gem.info;

    puts "Name: #{gem.name}\n"
    puts "Description: #{info}\n"
    puts "Licenses: #{gem.licenses != nil ? gem.licenses.join(', ') : ''}"
    puts "Downloads: #{gem.downloads}"
    puts "Downloads: #{format_number(gem.downloads)}"
  end

  def display_gems(gems)
    puts "---------------------------------\n"
    puts "Found #{gems.count} gems\n"
    for gem in gems
      display_gem(gem)
    end
    puts "---------------------------------\n"
  end

  def format_number(number)
    number_as_string = number.to_s
    formatted_number = ' '

    for i in 0..number_as_string.length - 1
      reversed_i = number_as_string.length - 1 - i
      formatted_number.insert(0, number_as_string[reversed_i])

      if ((i + 1) % 3 == 0 && i != number_as_string.length - 1)
        formatted_number.insert(0, ',')
      end
    end

    formatted_number
  end

end
