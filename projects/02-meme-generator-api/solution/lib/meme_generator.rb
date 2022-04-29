require 'mini_magick'
require 'open-uri'
require './entities/meme_arguments'

module MemeGenerator
  def self.generate_meme(arguments)
    if (arguments.original_image_path == nil || arguments.final_image_path == nil)
      raise 'You need to provide at least original_image_path and final_image_path in order to generate some spicy memes'
    end

    if (arguments.captions.count == 0)
      raise 'How can you expect to generate a meme without captions?'
    end

    original_image_path = arguments.original_image_path
    temp_image_path = nil

    if (is_url(arguments.original_image_path))
      temp_image_path = Time.now.to_i.to_s
      URI.open(arguments.original_image_path.chomp) do |image|
        File.open(temp_image_path, "wb") do |file|
          file.write(image.read)
        end
      end
    end

    image = MiniMagick::Image.open(original_image_path)
    
    for caption in arguments.captions
      image.combine_options do |c|
        c.stroke(caption.under_color)
        c.strokewidth(1)
        c.fill(caption.fill_color)
        c.pointsize caption.point_size
        c.font(caption.font)
        c.gravity("Center")
        c.draw("text #{caption.position_x},#{caption.position_y} '#{caption.text}'")
      end
    end

    if (temp_image_path != nil)
      File.delete(temp_image_path)
    end

    image.write(arguments.final_image_path)
    File.expand_path(arguments.final_image_path)
  end

  private

  def self.is_url(path)
    path.include?('http')
  end
end
