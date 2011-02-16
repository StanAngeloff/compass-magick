module Compass::Magick::Commands
  class Border < Compass::Magick::Command
    include Compass::Magick::Util

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
      radius = number_value(@radius, [image.rows, image.columns].max - 1, 0)
      width  = number_value(@width,  [image.rows, image.columns].max - 1, 1)
      offset = (width.to_f - 1) / 2;
      draw   = Magick::Draw.new
      if @color.is_a?(Compass::Magick::Types::Colors::LinearGradient)
        mask = Magick::Image.new(image.columns, image.rows) do
          self.background_color = 'black'
        end
        x1 = number_value(@x1, image.columns, 0)
        y1 = number_value(@y1, image.rows,    0)
        x2 = number_value(@x2, image.columns, image.columns)
        y2 = number_value(@y2, image.rows,    image.rows)
        gradient = @color.invoke x2 - x1, y2 - y1
        draw.stroke('white').fill('black')
      else
        draw.stroke(@color.to_s).fill('none')
      end
      draw.stroke_width = width
      draw.roundrectangle(
        number_value(@x1, image.columns - 1, 0) + offset,
        number_value(@y1, image.rows - 1,    0) + offset,
        number_value(@x2, image.columns - 1, image.columns - 1) - offset,
        number_value(@y2, image.rows - 1,    image.rows - 1) - offset,
        radius, radius
      )
      if gradient
        draw.draw(mask)
        mask.alpha(Magick::CopyAlphaChannel)
        mask.composite!(gradient, Magick::CenterGravity, Magick::InCompositeOp)
        image.composite(mask, x1, y1, @color.mode)
      else
        draw.draw(image)
      end
    end
  end
end
