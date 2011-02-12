module Compass::Magick::Commands
  class Erase < Compass::Magick::Command
    def initialize(color, x = nil, y = nil, width = nil, height = nil)
      @color  = color
      @x      = x
      @y      = y
      @width  = width
      @height = height
    end

    def invoke(image)
      draw = Magick::Draw.new
      draw.fill = @color.to_s
      draw.rectangle(
        Compass::Magick::Util.number_value(@x,      image.columns, 0),
        Compass::Magick::Util.number_value(@y,      image.rows,    0),
        Compass::Magick::Util.number_value(@width,  image.columns, image.columns),
        Compass::Magick::Util.number_value(@height, image.rows,    image.rows)
      )
      draw.draw(image)
    end
  end
end
