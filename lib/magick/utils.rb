module Compass::Magick
  # Utilities methods used throughout Compass Magick.
  module Utils
    extend self

    # Checks if <tt>arg</tt> is of the expected <tt>type</tt> and raises a
    # {TypeMismatch} exception otherwise.
    #
    # @param [String] name The argument name (used in the exception message).
    # @param [Object] arg The argument to validate.
    # @param [Object] type The expected <tt>arg</tt> type.
    def assert_type(name, arg, type)
      raise TypeMismatch.new "(#{self.class}) Type mismatch for argument '#{name}'; expected #{type} got #{arg.class}(#{arg.inspect}) instead" unless arg.kind_of? type
    end

    # Converts a Sass::Script::Color to ChunkyPNG::Color object.
    #
    # @param [Sass::Script::Color] color The source color in Sass' format.
    # @return [ChunkyPNG::Color] The source color in ChunkyPNG's format.
    def to_chunky_color(color)
      ChunkyPNG::Color.rgba(color.red, color.green, color.blue, color.alpha * 255)
    end

    # Converts the Sass::Script::Number to a fixed value.
    #
    # @param [Sass::Script::Number] number The number to convert.
    # @param [Float] max The maximum allowed value for this number.
    # @param [Float] default The default value for this number.
    # @return [Float]
    #   If <tt>number</tt> is <tt>nil</tt>, <tt>true</tt> or <tt>false</tt>, the <tt>default</tt> is returned.
    #   If <tt>number</tt>'s units are '%', it is calculated as a percentage of <tt>max</tt>.
    #   If the value is negative, it is calculated as an offset against <tt>max</tt>.
    #   Otherwise, the value is returned as-is.
    def value_of(number, max, default = nil)
      return default if number.nil? || (number.kind_of?(Sass::Script::Bool) && ! number.value)
      assert_type 'number', number, Sass::Script::Number
      return max * (number.value.to_f / 100) if number.unit_str == '%'
      return max + number.value if number.value < 0
      number.value
    end

    # A helper Point(x, y) structure.
    class Point < Struct.new(:x, :y); end
  end
end
