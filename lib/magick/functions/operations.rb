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
          canvas_x = Compass::Magick::Utils.value_of(x, canvas.width  - overlay.width,  0).to_i
          canvas_y = Compass::Magick::Utils.value_of(y, canvas.height - overlay.height, 0).to_i
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

      # Apply an effect on the {Canvas}.
      #
      # @param [Sass::Script::String] name The name of the effect to apply.
      # @param [Array] args The arguments to pass to the effect.
      # @return {Effect} A command which applies the effect to the canvas.
      def magick_effect(name, *args)
        Compass::Magick::Utils.assert_type 'name', name, Sass::Script::String
        Compass::Magick::Functions::Operations::Effects.send(name.value, *args)
      end

      # Apply drop shadow on the {Canvas}.
      #
      # The alpha channel is used to construct a mask of the original image
      # which is then used as a base for the horizontal/vertical shadow pass.
      #
      # @param [Sass::Script::Number] angle The angle of the shadow.
      # @param [Sass::Script::Number] distance The distance of the shadow from
      #   the original canvas.
      # @param [Sass::Script::Number] size The size (blur) of the shadow.
      # @param [Sass::Script::Color] color The color of the shadow.
      # @return {Command} A command which applies the drop shadow to the
      #   canvas.
      def magick_drop_shadow(angle = nil, distance = nil, size = nil, color = nil)
        Compass::Magick::Utils.assert_type 'angle',    angle,    Sass::Script::Number
        Compass::Magick::Utils.assert_type 'distance', distance, Sass::Script::Number
        Compass::Magick::Utils.assert_type 'size',     size,     Sass::Script::Number
        Compass::Magick::Utils.assert_type 'color',    color,    Sass::Script::Color
        Command.new do |canvas|
          shadow_angle    = Compass::Magick::Utils.value_of(angle,    360,                               0)
          shadow_distance = Compass::Magick::Utils.value_of(distance, [canvas.width, canvas.height].min, 5)
          shadow_size     = Compass::Magick::Utils.value_of(size,     [canvas.width, canvas.height].min, 5)
          shadow_color    = Compass::Magick::Utils.to_chunky_color(color.nil? ? Sass::Script::Color.new([0, 0, 0, 1]) : color)
          shadow_canvas   = ChunkyPNG::Canvas.new(canvas.width + shadow_size * 2, canvas.height + shadow_size * 2).replace(canvas, shadow_size, shadow_size)
          shadow_pixels   = shadow_canvas.pixels
          shadow_red      = ChunkyPNG::Color.r(shadow_color)
          shadow_green    = ChunkyPNG::Color.g(shadow_color)
          shadow_blue     = ChunkyPNG::Color.b(shadow_color)
          shadow_alpha    = ChunkyPNG::Color.a(shadow_color)
          angle_radians   = shadow_angle * Math::PI / 180
          distance_x      = (Math.cos(angle_radians) * shadow_distance).to_i
          distance_y      = (Math.sin(angle_radians) * shadow_distance).to_i
          left            = (shadow_size - 1) >> 1
          right           = shadow_size - left
          x_start         = left
          x_finish        = shadow_canvas.width - right
          y_start         = left
          y_finish        = shadow_canvas.height - right
          a_history       = Array.new(shadow_size)
          history_index   = 0
          sum_divider     = (shadow_alpha / 255.0) / shadow_size
          buffer_offset   = 0
          last_pixel_offset = right * shadow_canvas.width
          for y in (0...shadow_canvas.height)
            a_sum         = 0
            history_index = 0
            for x in (0...shadow_size)
              a = ChunkyPNG::Color.a(shadow_pixels[buffer_offset])
              a_history[x]  = a
              a_sum         = a_sum + a
              buffer_offset = buffer_offset + 1
            end
            buffer_offset = buffer_offset - right
            for x in (x_start...x_finish)
              a = a_sum * sum_divider
              shadow_pixels[buffer_offset] = ChunkyPNG::Color.rgba(shadow_red, shadow_green, shadow_blue, (shadow_alpha * (a / 255.0)).to_i)
              a_sum = a_sum - a_history[history_index]
              a = ChunkyPNG::Color.a(shadow_pixels[buffer_offset + right])
              a_history[history_index] = a
              a_sum = a_sum + a
              history_index = history_index + 1
              history_index = history_index - shadow_size if history_index >= shadow_size
              buffer_offset = buffer_offset + 1
            end
            buffer_offset = y * shadow_canvas.width
          end
          buffer_offset = 0
          for x in (0...shadow_canvas.width)
            a_sum         = 0
            history_index = 0
            for y in (0...shadow_size)
              a = ChunkyPNG::Color.a(shadow_pixels[buffer_offset])
              a_history[y]  = a
              a_sum         = a_sum + a
              buffer_offset = buffer_offset + shadow_canvas.width
            end
            buffer_offset = buffer_offset - last_pixel_offset
            for y in (y_start...y_finish)
              a = a_sum * sum_divider
              shadow_pixels[buffer_offset] = ChunkyPNG::Color.rgba(shadow_red, shadow_green, shadow_blue, (shadow_alpha * (a / 255.0)).to_i)
              a_sum = a_sum - a_history[history_index]
              a = ChunkyPNG::Color.a(shadow_pixels[buffer_offset + last_pixel_offset])
              a_history[history_index] = a
              a_sum = a_sum + a
              history_index = history_index + 1
              history_index = history_index - shadow_size if history_index >= shadow_size
              buffer_offset = buffer_offset + shadow_canvas.width
            end
            buffer_offset = x
          end
          for y in 0...canvas.height do
            for x in 0...canvas.width do
              shadow_x = x + shadow_size + distance_x
              shadow_y = y + shadow_size + distance_y
              canvas.set_pixel(x, y, ChunkyPNG::Color.compose_precise(
                canvas.get_pixel(x, y),
                shadow_pixels[shadow_y * shadow_canvas.width + shadow_x]
              ))
            end
          end
        end
      end
    end
  end
end
