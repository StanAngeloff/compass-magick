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
      raise TypeMismatch.new("(#{self.class}) Type mismatch for argument '#{name}'; " +
          "expected #{type} got #{arg.class}(#{arg.inspect}) instead") unless
        arg.nil? ||
        arg.kind_of?(type)
    end

    # Checks if <tt>arg</tt> is a sub-class of any of the supported
    # <tt>types</tt> and raises a {NotSupported} exception otherwise.
    #
    # @param [String] name The argument name or method signature (used in the
    #   exception message).
    # @param [Object] arg The argument to validate.
    # @param [Array<Object>] types The list of supported <tt>arg</tt> types.
    def assert_one_of(name, arg, *types)
      for type in types do
        return if arg.kind_of?(type)
      end
      raise NotSupported.new("#{name} expected argument of type [#{types.join ', '}] got #{arg.class}(#{arg.inspect}) instead")
    end

    # Converts a Sass::Script::Color to ChunkyPNG::Color object.
    #
    # @param [Sass::Script::Color] color The source color in Sass' format.
    # @return [ChunkyPNG::Color] The source color in ChunkyPNG's format.
    def to_chunky_color(color)
      ChunkyPNG::Color.rgba(color.red, color.green, color.blue, color.alpha * 255)
    end

    # Converts a fill type (solid color or gradient) to a {Canvas} object.
    #
    # @param [Object] type The type of fill type to convert. Supported:
    #   * Sass::Script::Color
    #   * Sass::Script::String
    #   * {Compass::Magick::Types::Solid}
    #   * {Compass::Magick::Types::Gradients::Linear}
    # @param [Sass::Script::Number] width The width of the generated
    #   {Canvas}.
    # @param [Sass::Script::Number] height The height of the generated
    #   {Canvas}.
    # @return [Canvas] The canvas in the dimensions given with the fill
    #   type applied.
    def to_canvas(type, width, height)
      Compass::Magick::Utils.assert_one_of 'to_canvas(..)', type, Sass::Script::Color, Sass::Script::String,Compass::Magick::Type
      if type.kind_of?(Sass::Script::Color)
        Compass::Magick::Types::Solid.new(type).to_canvas(width, height)
      elsif type.kind_of?(Sass::Script::String)
        if type.value == 'transparent'
          ChunkyPNG::Canvas.new(width.value, height.value, ChunkyPNG::Color.rgba(0, 0, 0, 0))
        else
          raise NotSupported.new("to_canvas(..) supports String argument of values ['transparent'] got '#{type}' instead")
        end
      elsif type.kind_of?(Compass::Magick::Types::Solid) || type.kind_of?(Compass::Magick::Types::Gradients::Linear)
        type.to_canvas(width, height)
      end
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
