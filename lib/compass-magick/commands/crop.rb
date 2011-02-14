module Compass::Magick::Commands
  class Crop < Compass::Magick::Command
    include Compass::Magick::Util

    def initialize(x1 = nil, y1 = nil, x2 = nil, y2 = nil)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
    end

    def invoke(image)
      x1 = number_value(@x1, image.columns - 1, 0)
      y1 = number_value(@y1, image.rows - 1,    0)
      x2 = number_value(@x2, image.columns - 1, image.columns - 1)
      y2 = number_value(@y2, image.rows - 1,    image.rows - 1)
      x1, x2 = x2, x1 if x1 > x2
      y1, y2 = y2, y1 if y1 > y2
      image.crop(x1, y1, x2 - x1, y2 - y1)
    end
  end
end
