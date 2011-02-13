module Compass::Magick::Commands
  class Border < Compass::Magick::Command
    def initialize(color, width = nil, radius = nil, x1 = nil, y1 = nil, x2 = nil, y2 = nil)
      @color  = color
      @width  = width
      @radius = radius
      @x1     = x1
      @y1     = y1
      @x2     = x2
      @y2     = y2
    end

    def invoke(image)
      radius = Compass::Magick::Util.number_value(@radius, [image.rows, image.columns].max - 1, 0)
      width  = Compass::Magick::Util.number_value(@width,  [image.rows, image.columns].max - 1, 1)
      offset = (width.to_f - 1) / 2;
      draw = Magick::Draw.new
      draw.fill   = 'none'
      draw.stroke = @color.to_s
      draw.stroke_width = width
      draw.roundrectangle(
        Compass::Magick::Util.number_value(@x1, image.columns - 1, 0) + offset,
        Compass::Magick::Util.number_value(@y1, image.rows - 1,    0) + offset,
        Compass::Magick::Util.number_value(@x2, image.columns - 1, image.columns - 1) - offset,
        Compass::Magick::Util.number_value(@y2, image.rows - 1,    image.rows - 1) - offset,
        radius, radius
      )
      draw.draw(image)
    end
  end
end
