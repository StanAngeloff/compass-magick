module Compass::Magick::Commands
  class Composite < Compass::Magick::Command
    include Compass::Magick::Util

    def initialize(*args)
      @source = args.shift
      @x      = args.shift if args[0].is_a?(Sass::Script::Number)
      @y      = args.shift if args[0].is_a?(Sass::Script::Number)
      @invert = args.shift if args[0].is_a?(Sass::Script::Bool)
      @mode   = args.shift
    end

    def invoke(image)
      x    = number_value(@x, image.columns - 1, 0);
      y    = number_value(@y, image.rows - 1,    0);
      mode = Magick.const_get("#{@mode ? @mode.value : 'SrcOver'}CompositeOp")
      if @invert && @invert.value
        external.composite(image, x, y, mode)
      else
        image.composite(external, x, y, mode)
      end
    end

    def external
      layer = (@source.value.include?('[') ? @source.value.split('[').pop().split(']').shift().to_i : 0)
      path  = File.join(Compass.configuration.images_path, @source.value.split(/[\?\[]/).shift());
      Magick::Image.read(path)[layer]
    end
  end
end
