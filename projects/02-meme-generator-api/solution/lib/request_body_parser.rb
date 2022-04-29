require 'json'
require './entities/meme_arguments'
require './entities/meme_caption'
require './entities/signup_arguments'
require './entities/login_arguments'

module RequestBodyParser
  def self.extract_meme_arguments(request_body_contents)
    request_payload = JSON.parse(request_body_contents)
    captions = extract_meme_captions(request_payload)

    meme_arguments = MemeArguments.new(
      request_payload['original_image_path'],
      request_payload['final_image_path'],
      captions)
  end

  def self.extract_signup_arguments(request_body_contents)
    request_payload = JSON.parse(request_body_contents)
    SignupArguments.new(request_payload['username'], request_payload['password'])
  end

  def self.extract_login_arguments(request_body_contents)
    request_payload = JSON.parse(request_body_contents)
    LoginArguments.new(request_payload['username'], request_payload['password'])
  end

  private

  def self.extract_meme_captions(request_payload)
    captions_payload = request_payload['captions']
    captions = []

    if (captions_payload == nil || !captions_payload.kind_of?(Array))
      return captions
    end

    for caption_payload in captions_payload
      caption = MemeCaption.new(
        caption_payload['text'],
        caption_payload['font'] || 'Arial',
        caption_payload['fill_color'] || 'White',
        caption_payload['under_color'] || 'Black',
        caption_payload['point_size'] != nil ? caption_payload['point_size'].to_i : 8,
        caption_payload['position_x'] != nil ? caption_payload['position_x'].to_i : 0,
        caption_payload['position_y'] != nil ? caption_payload['position_y'].to_i : 0)

      captions.push(caption)
    end

    captions
  end
end
