module Compass::Magick
  module Functions
    # Methods for operating on a {Compass::Magick::Canvas}, e.g., crop,
    # composite, etc.
    module Operations
      # Composes one {Canvas} on top of another.
      #
      # @param [Canvas] canvas The Canvas object to compose.
      # @param [Integer] x The left coordinate of the composition operation.
      # @param [Integer] y The top coordinate of the composition operation.
      # @return {Command} A command which composes the two canvas objects
      #   together.
      def magick_composite(source, x = nil, y = nil)
        Compass::Magick::Utils::assert_type 'source', source, Compass::Magick::Canvas
        Command.new do |canvas|
          canvas_x = Compass::Magick::Utils.value_of(x, canvas.width  - source.width,  0)
          canvas_y = Compass::Magick::Utils.value_of(y, canvas.height - source.height, 0)
          canvas.compose(source, canvas_x, canvas_y)
        end
      end
    end
  end
end
