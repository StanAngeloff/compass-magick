module Compass::Magick
  module Types
    # A type that generates a {Canvas} from a region filled with a solid
    # color.
    #
    # @example
    #
    #     Solid.new(Sass::Script::Color.new([255, 255, 255])).to_canvas(
    #       Sass::Script::Number(320),
    #       Sass::Script::Number(200)
    #     )
    class Solid < Type
      include Compass::Magick::Utils

      # Initializes a new Solid instance.
      #
      # @param [Sass::Script::Color] color The solid background color.
      def initialize(color)
        assert_type 'color', color, Sass::Script::Color
        @color = color
      end

      # @return [Sass::Script::Color] The solid background color.
      attr_reader :color

      def to_canvas(width, height)
        assert_type 'width',  width,  Sass::Script::Number
        assert_type 'height', height, Sass::Script::Number
        color = ChunkyPNG::Color.rgba(@color.red, @color.green, @color.blue, @color.alpha * 255)
        Canvas.new(width, height).rect(0, 0, width.value - 1, height.value - 1, ChunkyPNG::Color::TRANSPARENT, color)
      end
    end
  end
end
