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

      # Crop the {Canvas} to the given region.
      #
      # @param [Integer] x1 The left coordinate of the crop operation.
      # @param [Integer] y1 The top coordinate of the crop operation.
      # @param [Integer] x2 The right coordinate of the crop operation.
      # @param [Integer] y2 The bottom coordinate of the crop operation.
      # @return {Command} A command which applies the crop on the canvas.
      def magick_crop(x1 = nil, y1 = nil, x2 = nil, y2 = nil)
        Compass::Magick::Utils.assert_type 'x1', x1, Sass::Script::Number
        Compass::Magick::Utils.assert_type 'y1', y1, Sass::Script::Number
        Compass::Magick::Utils.assert_type 'x2', x2, Sass::Script::Number
        Compass::Magick::Utils.assert_type 'y2', y2, Sass::Script::Number
        Command.new do |canvas|
          canvas_x1 = Compass::Magick::Utils.value_of(x1, canvas.width,  0)
          canvas_y1 = Compass::Magick::Utils.value_of(y1, canvas.height, 0)
          canvas_x2 = Compass::Magick::Utils.value_of(x2, canvas.width,  canvas.width)
          canvas_y2 = Compass::Magick::Utils.value_of(y2, canvas.height, canvas.height)
          canvas_x1, canvas_x2 = canvas_x2, canvas_x1 if canvas_x1 > canvas_x2
          canvas_y1, canvas_y2 = canvas_y2, canvas_y1 if canvas_y1 > canvas_y2
          width     = canvas_x2 - canvas_x1
          height    = canvas_y2 - canvas_y1
          canvas.crop(canvas_x1, canvas_y1, width, height)
        end
      end
    end
  end
end
