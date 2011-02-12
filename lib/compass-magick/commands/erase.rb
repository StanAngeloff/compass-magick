module Compass::Magick::Commands
  class Erase < Compass::Magick::Command
    def initialize(color, x1 = nil, y1 = nil, x2 = nil, y2 = nil)
      @color = color
      @x1    = x1
      @y1    = y1
      @x2    = x2
      @y2    = y2
    end

    def invoke(image)
      draw = Magick::Draw.new
      draw.fill = @color.to_s
      draw.rectangle(
        Compass::Magick::Util.number_value(@x1, image.columns, 0),
        Compass::Magick::Util.number_value(@y1, image.rows,    0),
        Compass::Magick::Util.number_value(@x2, image.columns, image.columns),
        Compass::Magick::Util.number_value(@y2, image.rows,    image.rows)
      )
      draw.draw(image)
    end
  end
end
