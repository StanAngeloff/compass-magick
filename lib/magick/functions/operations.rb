module Compass::Magick
  module Functions
    # Methods for operating on a {Compass::Magick::Canvas}, e.g., crop,
    # compose, etc.
    module Operations
      # Composes one {Canvas} on top of another.
      #
      # @overload magick_compose(another, invert, x = nil, y = nil)
      #   @param [Canvas] another The Canvas object to compose.
      #   @param [Bool] invert <tt>true</tt> to use the target canvas as the
      #     source, <tt>false</tt> (default) otherwise.
      #   @param [Integer] x The left coordinate of the composition
      #     operation.
      #   @param [Integer] y The top coordinate of the composition operation.
      # @overload magick_compose(another, x = nil, y = nil)
      #   @param [Canvas] another The Canvas object to compose.
      #   @param [Integer] x The left coordinate of the composition
      #     operation.
      #   @param [Integer] y The top coordinate of the composition operation.
      # @return {Command} A command which composes the two canvas objects
      #   together.
      def magick_compose(another, *args)
        Compass::Magick::Utils.assert_type 'another', another, Compass::Magick::Canvas
        invert = args.shift.value if args.first.kind_of?(Sass::Script::Bool)
        x, y   = args
        Compass::Magick::Utils.assert_type 'x', x, Sass::Script::Number
        Compass::Magick::Utils.assert_type 'y', y, Sass::Script::Number
        Command.new do |canvas|
          if invert
            another_x = Compass::Magick::Utils.value_of(x, another.width  - canvas.width,  0)
            another_y = Compass::Magick::Utils.value_of(y, another.height - canvas.height, 0)
            another.compose(canvas, another_x, another_y)
          else
            canvas_x = Compass::Magick::Utils.value_of(x, canvas.width  - another.width,  0)
            canvas_y = Compass::Magick::Utils.value_of(y, canvas.height - another.height, 0)
            canvas.compose(another, canvas_x, canvas_y)
          end
        end
      end

      # Crops the {Canvas} to the given region.
      #
      # @param [Integer] x1 The left coordinate of the crop operation.
      # @param [Integer] y1 The top coordinate of the crop operation.
      # @param [Integer] x2 The right coordinate of the crop operation.
      # @param [Integer] y2 The bottom coordinate of the crop operation.
      # @return {Command} A command which applies the crop to the canvas.
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

      # Applies the mask on the {Canvas}.
      #
      # Composes the alpha channel from the <tt>mask</tt> image with the
      # one from the canvas and return the original canvas with the
      # alpha-channel modified.
      #
      # @param [Integer] x The left coordinate of the mask operation.
      # @param [Integer] y The top coordinate of the mask operation.
      # @return {Command} A command which applies the mask on the canvas.
      def magick_mask(mask, x = nil, y = nil)
        Compass::Magick::Utils.assert_type 'mask', mask, Compass::Magick::Canvas
        Compass::Magick::Utils.assert_type 'x',    x,    Sass::Script::Number
        Compass::Magick::Utils.assert_type 'y',    y,    Sass::Script::Number
        Command.new do |canvas|
          canvas_x = Compass::Magick::Utils.value_of(x, canvas.width  - 1,  0)
          canvas_y = Compass::Magick::Utils.value_of(y, canvas.height - 1, 0)
          raise ChunkyPNG::OutOfBounds, 'Canvas image width is too small to fit mask'  if canvas.width  < mask.width  + canvas_x
          raise ChunkyPNG::OutOfBounds, 'Canvas image height is too small to fit mask' if canvas.height < mask.height + canvas_y
          for y in 0...mask.width do
            for x in 0...mask.height do
              canvas_pixel = canvas.get_pixel(x + canvas_x, y + canvas_y)
              mask_alpha   = ChunkyPNG::Color.a(mask.get_pixel(x, y))
              canvas_red   = ChunkyPNG::Color.r(canvas_pixel)
              canvas_green = ChunkyPNG::Color.g(canvas_pixel)
              canvas_blue  = ChunkyPNG::Color.b(canvas_pixel)
              canvas_alpha = ChunkyPNG::Color.a(canvas_pixel) * (ChunkyPNG::Color.a(mask.get_pixel(x, y)).to_f / 255)
              canvas.set_pixel(x + canvas_x, y + canvas_y, ChunkyPNG::Color.rgba(canvas_red, canvas_green, canvas_blue, canvas_alpha))
            end
          end
        end
      end
    end
  end
end
