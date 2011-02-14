require 'base64'

module Compass::Magick::Commands

  class Util
    include Compass::Magick::Util
  end

  class Composite < Compass::Magick::Command
    def initialize(*args)
      @source = args.shift
      @x      = args.shift if args[0].is_a?(Sass::Script::Number)
      @y      = args.shift if args[0].is_a?(Sass::Script::Number)
      @invert = args.shift if args[0].is_a?(Sass::Script::Bool)
      @mode   = args.shift
    end

    def invoke(image)
      source = read
      x      = number_value(@x, image.columns - 1, source.columns - 1, 0);
      y      = number_value(@y, image.rows - 1,    source.rows - 1,    0);
      mode   = Magick.const_get("#{@mode ? @mode.value : 'SrcOver'}CompositeOp")
      if @invert && @invert.value
        source.composite(image, x, y, mode)
      else
        image.composite(source, x, y, mode)
      end
    end

    def read
      source = @source.value
      if source.index('url(') === 0
        if source.include?('base64,')
          encoded = source.match(/base64,([a-zA-Z0-9+\/=]+)/)[1]
          blob    = Base64.decode64(encoded)
          Magick::Image.from_blob(blob)[0]
        else
          filename = source.gsub(/^url\(['"]?|["']?\)$/, '')
          path     = File.join(Compass.configuration.css_path, filename.split(/[?\[]/).shift());
          Magick::Image.read(path)[0]
        end
      else
        layer = (source.include?('[') ? source.match(/\[(\d+)\]/)[1].to_i : 0)
        path  = File.join(Compass.configuration.images_path, source.split(/[?\[]/).shift());
        Magick::Image.read(path)[layer]
      end
    end

    def number_value(number, dst_length, src_length, default = nil)
      if number && number.unit_str === '%'
        (dst_length - src_length) * (number.value.to_f / 100)
      else
        Util.new.number_value(number, dst_length, default)
      end
    end
  end
end
