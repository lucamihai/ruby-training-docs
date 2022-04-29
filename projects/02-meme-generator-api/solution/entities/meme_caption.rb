class MemeCaption
  @text
  @font
  @fill_color
  @under_color
  @point_size
  @position_x
  @position_y

  attr_accessor :text
  attr_accessor :font
  attr_accessor :fill_color
  attr_accessor :under_color
  attr_accessor :point_size
  attr_accessor :position_x
  attr_accessor :position_y

  def initialize(
    text,
    font,
    fill_color,
    under_color,
    point_size,
    position_x,
    position_y)

    @text = text
    @font = font
    @fill_color = fill_color
    @under_color = under_color
    @point_size = point_size
    @position_x = position_x
    @position_y = position_y
  end
end
