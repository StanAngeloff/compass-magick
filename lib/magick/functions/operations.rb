require 'magick/functions/operations/effects'

module Compass::Magick
  module Functions
    # Methods for operating on a {Compass::Magick::Canvas}, e.g., crop,
    # compose, etc.
    module Operations
      # Composes one {Canvas} on top of another.
      #
      # @param [Canvas] overlay The Canvas object to compose.
      # @param [Integer] x The left coordinate of the composition operation.
      # @param [Integer] y The top coordinate of the composition operation.
      # @return {Command} A command which composes the two canvas objects
      #   together.
      def magick_compose(overlay, x = nil, y = nil)
        Compass::Magick::Utils.assert_type 'overlay', overlay, ChunkyPNG::Canvas
        Compass::Magick::Utils.assert_type 'x', x, Sass::Script::Number
        Compass::Magick::Utils.assert_type 'y', y, Sass::Script::Number
        Command.new do |canvas|
          canvas_x = Compass::Magick::Utils.value_of(x, canvas.width  - overlay.width,  0)
          canvas_y = Compass::Magick::Utils.value_of(y, canvas.height - overlay.height, 0)
          raise ChunkyPNG::OutOfBounds, 'Canvas image width is too small to compose overlay'  if canvas.width  < overlay.width  + canvas_x
          raise ChunkyPNG::OutOfBounds, 'Canvas image height is too small to compose overlay' if canvas.height < overlay.height + canvas_y
          for y in 0...overlay.height do
            for x in 0...overlay.width do
              overlay_pixel = overlay.get_pixel(x, y)
              canvas_pixel  = canvas.get_pixel(x + canvas_x, y + canvas_y)
              canvas.set_pixel(x + canvas_x, y + canvas_y, ChunkyPNG::Color.compose_precise(overlay_pixel, canvas_pixel))
            end
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
      # alpha-channel modified. Any opaque pixels from the <tt>mask</tt> are
      # converted to grayscale using BT709 luminosity factors, i.e. black is
      # fully transparent and white is fully opaque.
      #
      # @param [Integer] x The left coordinate of the mask operation.
      # @param [Integer] y The top coordinate of the mask operation.
      # @return {Command} A command which applies the mask on the canvas.
      def magick_mask(mask, x = nil, y = nil)
        Compass::Magick::Utils.assert_type 'mask', mask, ChunkyPNG::Canvas
        Compass::Magick::Utils.assert_type 'x',    x,    Sass::Script::Number
        Compass::Magick::Utils.assert_type 'y',    y,    Sass::Script::Number
        Command.new do |canvas|
          canvas_x = Compass::Magick::Utils.value_of(x, canvas.width  - 1,  0)
          canvas_y = Compass::Magick::Utils.value_of(y, canvas.height - 1, 0)
          raise ChunkyPNG::OutOfBounds, 'Canvas image width is too small to fit mask'  if canvas.width  < mask.width  + canvas_x
          raise ChunkyPNG::OutOfBounds, 'Canvas image height is too small to fit mask' if canvas.height < mask.height + canvas_y
          for y in 0...mask.height do
            for x in 0...mask.width do
              canvas_pixel = canvas.get_pixel(x + canvas_x, y + canvas_y)
              mask_pixel   = mask.get_pixel(x, y)
              mask_alpha   = (ChunkyPNG::Color.r(mask_pixel) * 0.2125 + ChunkyPNG::Color.g(mask_pixel) * 0.7154 + ChunkyPNG::Color.b(mask_pixel) * 0.0721) * (ChunkyPNG::Color.a(mask_pixel) / 255.0)
              canvas.set_pixel(x + canvas_x, y + canvas_y, ChunkyPNG::Color.rgba(
                ChunkyPNG::Color.r(canvas_pixel),
                ChunkyPNG::Color.g(canvas_pixel),
                ChunkyPNG::Color.b(canvas_pixel),
                ChunkyPNG::Color.a(canvas_pixel) * (mask_alpha / 255.0)
              ))
            end
          end
        end
      end
    end

    # Apply an effect on the {Canvas}.
    #
    # @param [Sass::Script::String] name The name of the effect to apply.
    # @param [Array] args The arguments to pass to the effect.
    # @return {Effect} A command which applies the effect to the canvas.
    def magick_effect(name, *args)
      Compass::Magick::Utils.assert_type 'name', name, Sass::Script::String
      Compass::Magick::Functions::Operations::Effects.send(name.value, *args)
    end
  end
end
