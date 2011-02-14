module Compass::Magick::Commands::Gradients

  class Linear < Compass::Magick::Command
    include Compass::Magick::Util

    def initialize(*args)
      @stops = []
      while args.length && (args[0].is_a?(Sass::Script::Color) || args[0].is_a?(ColorStop))
        @stops.push args.shift
      end
      @angle = args.shift
      @x1    = args.shift
      @y1    = args.shift
      @x2    = args.shift
      @y2    = args.shift
      @mode  = args.shift
    end

    def invoke(image)
      x1 = number_value(@x1, image.columns - 1, 0);
      y1 = number_value(@y1, image.rows - 1,    0);
      x2 = number_value(@x2, image.columns - 1, image.columns - 1);
      y2 = number_value(@y2, image.rows - 1,    image.rows - 1);
      angle    = number_value(@angle, 0, 90)
      width    = x2 - x1
      height   = y2 - y1
      args     = sparse_args angle, width, height
      gradient = Magick::Image.new(width, height) do
        self.background_color = 'none'
      end
      gradient = sparse_color gradient, *args
      if has_alpha?
        args = sparse_args angle, width, height, :alpha => true
        mask = Magick::Image.new(width, height) do
          self.background_color = 'black'
        end
        mask = mask.sparse_color(Magick::BarycentricColorInterpolate, *args)
        mask.matte     = false
        gradient.matte = true
        gradient.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
      end
      image.composite(gradient, x1, y1, Magick.const_get("#{@mode ? @mode.value : 'SrcOver'}CompositeOp"))
    end

    def sparse_args(angle, width, height, options = {})
      points        = []
      last_position = 0
      @stops.each do |stop|
        if stop.is_a?(Sass::Script::Color)
          if points.length > 0
            if points.length === @stops.length - 1
              position = 100
            else
              next_index    = 0
              next_position = nil
              @stops.slice(points.length, @stops.length).each do |next_stop|
                next_index = next_index + 1
                if next_stop.is_a?(ColorStop)
                  next_position = next_stop.position
                  break
                end
              end
              next_position = 100 if next_position.nil?
              position = last_position + (next_position - last_position) / next_index
            end
          else
            position = 0
          end
          points.push ColorStop.new(Sass::Script::Number.new(position), stop)
          last_position = position
        else
          points.push stop
          last_position = stop.position
        end
      end
      args = []
      start_x, start_y = coords(angle,      width, height)
      stop_x,  stop_y  = coords(angle + 90, width, height)
      delta_x, delta_y = stop_x - start_x, stop_y - start_y
      points.each do |point|
        args.push start_x + delta_x * (point.position / 100)
        args.push start_y + delta_y * (point.position / 100)
        args.push(options[:alpha] ? point.alpha_color : point.color)
      end
      args
    end

    def sparse_color(image, *args)
      begin
        return image.sparse_color(args.length > 6 ? Magick::BilinearColorInterpolate : Magick::BarycentricColorInterpolate, *args)
      rescue Magick::ImageMagickError
        return image.sparse_color(Magick::ShepardsColorInterpolate, *args)
      end
    end

    def coords(angle, width, height)
      angle = angle.to_f % 360
      if    angle >= 0   && angle < 90
        [(width.to_f - 1) * (angle / 90), 0]
      elsif angle >= 90  && angle < 180
        [width - 1, (height.to_f - 1) * ((angle - 90) / 90)]
      elsif angle >= 180 && angle < 270
        [width - 1 - (width.to_f - 1) * ((angle - 180) / 90), height - 1]
      elsif angle >= 270 && angle < 360
        [0, height - 1 - (height.to_f - 1) * ((angle - 270) / 90)]
      end
    end

    def has_alpha?
      @stops.each do |stop|
        return true if stop.alpha?
      end
      return false
    end
  end

  class ColorStop < Compass::Magick::Command
    def initialize(position, color)
      @position = position
      @color    = color
    end

    def position
      @position.value.to_f
    end

    def alpha?
      @color.alpha?
    end

    def color
      '#' + @color.rgb.map { |component| component.to_s(16).rjust(2, '0') }.join('')
    end

    def alpha_color
      value = (@color.alpha * 255).to_i.to_s(16).rjust(2, '0')
      "##{value}#{value}#{value}"
    end
  end
end
