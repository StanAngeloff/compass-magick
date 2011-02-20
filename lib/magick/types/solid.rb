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
        color  = to_chunky_color(@color)
        canvas = Canvas.new(width, height)
        (0...canvas.height).each do |y|
          (0...canvas.width).each do |x|
            canvas.set_pixel(x, y, color)
          end
        end
        canvas
      end
    end
  end
end
