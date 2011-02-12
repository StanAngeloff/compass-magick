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
      draw.rectangle(@x || 0, @y || 0, @width || image.columns, @height || image.rows)
      draw.draw(image)
    end
  end
end
