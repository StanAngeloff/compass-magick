module Compass::Magick

  # Exception that is raised when a pattern is not configured properly.
  class PatternException < Exception; end

  module Plugins
    # Draws a pattern and returns a B/W {Canvas} ready for masking.
    #
    # Chris Eppstein's original tweet:  
    # {http://twitter.com/chriseppstein/status/56095925843668992}
    #
    # @param [Sass::Script::Number] width The width of the pattern.
    # @param [Sass::Script::Number] height The height of the pattern.
    # @param [Sass::Script::List] values The pattern itself. This is a list
    #   of values (or a multi-line string) where `1`, `true`, `yes`, `X`, `*`
    #   and `+` mark where an opaque white pixel will be placed. Any other
    #   value is ignored and is transparent in the output. The size of the
    #   list must match the width/height.
    # @return {Canvas} A B/W Canvas with the pattern applied. The resulting
    #   image can be applied as a mask.
    # @example Diagonal stripes:
    #   magick-pattern(3, 3,
    #     x _ _
    #     _ x _
    #     _ _ x
    #   );
    def magick_pattern(width, height, values)
      Compass::Magick::Utils.assert_type   'width',              width,  Sass::Script::Number
      Compass::Magick::Utils.assert_type   'height',             height, Sass::Script::Number
      Compass::Magick::Utils.assert_one_of 'magick-pattern(..)', values, Sass::Script::List, Sass::Script::String
      if values.kind_of?(Sass::Script::String)
        list = values.value.strip().split(/[\r\n]+/).map { |line| line.strip().split(/\s/) }.flatten
      else
        list = values.value
      end
      size = width.value * height.value
      raise PatternException.new("magick-pattern(..) expects #{size} values, got #{list.size} instead: #{list.inspect}") unless size == list.size
      canvas = Canvas.new(width, height)
      opaque = ['1', 'true', 'yes', 'X', '*', '+']
      for y in (0...height.value)
        for x in (0...width.value)
          pixel = list[x + y * height.value].to_s.upcase
          canvas.set_pixel(x, y, ChunkyPNG::Color::WHITE) if opaque.include?(pixel)
        end
      end
      canvas
    end
  end
end
