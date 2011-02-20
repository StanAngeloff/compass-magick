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

    # A helper Point(x, y) structure.
    class Point < Struct.new(:x, :y); end
  end
end
