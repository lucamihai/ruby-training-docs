class MemeArguments
  @original_image_path
  @final_image_path
  @captions

  attr_accessor :original_image_path
  attr_accessor :final_image_path
  attr_accessor :captions

  def initialize(
    original_image_path,
    final_image_path,
    captions)

    @original_image_path = original_image_path
    @final_image_path = final_image_path
    @captions = captions
  end
end
