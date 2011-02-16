module Compass::Magick::Commands
  class Corners < Compass::Magick::Command
    include Compass::Magick::Util

    def initialize(corners, radius = nil)
      @corners = corners
      @radius  = radius
    end

    def invoke(image)
      radius = number_value(@radius, [image.rows, image.columns].max - 1, 10)
      mask   = Magick::Image.new(image.columns, image.rows) do
        self.background_color = 'black'
      end
      draw = Magick::Draw.new
      draw.stroke('white').fill('white')
      draw.roundrectangle(0, 0, image.columns - 1, image.rows - 1, radius, radius)
      draw.draw(mask)
      corners = {
        'top-left'     => [0, 0],
        'top-right'    => [image.columns - 1 - radius, 0],
        'bottom-right' => [image.columns - 1 - radius, image.rows - 1 - radius],
        'bottom-left'  => [0, image.rows - 1 - radius]
      }
      corners.keys.each do |corner|
        unless @corners.include?(corner)
          draw.rectangle(corners[corner][0], corners[corner][1], corners[corner][0] + radius, corners[corner][1] + radius).draw(mask)
        end
      end
      mask.alpha(Magick::CopyAlphaChannel)
      mask.composite(image, Magick::CenterGravity, Magick::InCompositeOp)
    end
  end
end
