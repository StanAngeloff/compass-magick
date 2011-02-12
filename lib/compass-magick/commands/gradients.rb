module Compass::Magick::Commands::Gradients
  class Linear < Compass::Magick::Command
    def initialize(start, stop, angle = 90, x1 = nil, y1 = nil, x2 = nil, y2 = nil, mode = Sass::Script::String.new('SrcOver'))
      @start = start
      @stop  = stop
      @angle = angle
      @x1    = x1
      @y1    = y1
      @x2    = x2
      @y2    = y2
      @mode  = mode
    end

    def invoke(image)
      x1 = Compass::Magick::Util.number_value(@x1, image.columns, 0);
      y1 = Compass::Magick::Util.number_value(@y1, image.rows,    0);
      x2 = Compass::Magick::Util.number_value(@x2, image.columns, image.columns);
      y2 = Compass::Magick::Util.number_value(@y2, image.rows,    image.rows);
      angle  = Compass::Magick::Util.number_value(@angle, 0, 90)
      width  = x2 - x1
      height = y2 - y1
      start_color = '#' + @start.rgb.map { |component| component.to_s(16).rjust(2, '0') }.join('')
      stop_color  = '#' + @stop.rgb.map  { |component| component.to_s(16).rjust(2, '0') }.join('')
      start_x, start_y = coords(angle,      width, height)
      stop_x,  stop_y  = coords(angle + 90, width, height)
      gradient = Magick::Image.new(width, height) do
        self.background_color = 'none'
      end
      gradient = gradient.sparse_color(Magick::BarycentricColorInterpolate, start_x, start_y, start_color, stop_x, stop_y, stop_color)
      if @start.alpha? || @stop.alpha?
        start_alpha = (@start.alpha * 255).to_i.to_s(16).rjust(2, '0')
        stop_alpha  = (@stop.alpha  * 255).to_i.to_s(16).rjust(2, '0')
        start_color = "##{start_alpha}#{start_alpha}#{start_alpha}"
        stop_color  = "##{stop_alpha}#{stop_alpha}#{stop_alpha}"
        mask = Magick::Image.new(width, height) do
          self.background_color = 'black'
        end
        mask = mask.sparse_color(Magick::BarycentricColorInterpolate, start_x, start_y, start_color, stop_x, stop_y, stop_color)
        mask.matte     = false
        gradient.matte = true
        gradient.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
      end
      image.composite(gradient, x1, y1, Magick.const_get("#{@mode.value}CompositeOp"))
    end

    def coords(angle, width, height)
      angle = angle.to_f % 360
      if    angle >= 0   && angle < 90
        [width.to_f * (angle / 90), 0]
      elsif angle >= 90  && angle < 180
        [width, height * ((angle - 90) / 90)]
      elsif angle >= 180 && angle < 270
        [width - width * ((angle - 180) / 90), height]
      elsif angle >= 270 && angle < 360
        [0, height - height * ((angle - 270) / 90)]
      end
    end
  end
end
