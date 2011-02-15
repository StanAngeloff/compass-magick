module Compass::Magick::Commands
  class Erase < Compass::Magick::Command
    include Compass::Magick::Util

    def initialize(color, x1 = nil, y1 = nil, x2 = nil, y2 = nil)
      @color = color
      @x1    = x1
      @y1    = y1
      @x2    = x2
      @y2    = y2
    end

    def invoke(image)
      x1 = number_value(@x1, image.columns - 1, 0)
      y1 = number_value(@y1, image.rows - 1,    0)
      x2 = number_value(@x2, image.columns - 1, image.columns - 1)
      y2 = number_value(@y2, image.rows - 1,    image.rows - 1)
      draw = Magick::Draw.new
      if @color.is_a?(Compass::Magick::Types::Colors::LinearGradient)
        gradient = @color.invoke image.columns, image.rows
        image.composite(gradient, x1, y1, @color.mode)
      else
        draw.fill = @color.to_s
        draw.rectangle(x1, y1, x2, y2)
        draw.draw(image)
      end
    end
  end
end
