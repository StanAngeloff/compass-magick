module Compass::Magick
  module Functions::Operations
    # Methods for performing various visual effects on a
    # {Compass::Magick::Canvas}, e.g., fade, desaturate, etc.
    module Effects
      extend self

      # Adjusts the intensity of a color by changing its alpha by a given
      # value.
      #
      # @param [Sass::Script::Number] adjust Fade value as a float between
      #   0.0 and 1.0.
      # @return {Effect} A command which applies the fade to the canvas.
      def fade(adjust = nil)
        Compass::Magick::Utils.assert_type 'adjust', adjust, Sass::Script::Number
        fade_adjust = 255 - (255 * Compass::Magick::Utils.value_of(adjust, 1.0, 0.5)).to_i
        Effect.new { |pixel| ChunkyPNG::Color.fade(pixel, fade_adjust) }
      end

      # Adjusts the brightness of a color by changing its [R, G, B]
      # components by a given value.
      #
      # Copyright (c) 2010, Ryan LeFevre
      # http://www.camanjs.com
      #
      # @param [Sass::Script::Number] adjust Brightness value as a float
      #   between -1.0 and 1.0.
      # @return {Effect} A command which applies the Brightness to the
      #   canvas.
      def brightness(adjust = nil)
        Compass::Magick::Utils.assert_type 'adjust', adjust, Sass::Script::Number
        brightness_adjust = 255 * Compass::Magick::Utils.value_of(adjust, 1.0, 0.5)
        Effect.new do |pixel|
          ChunkyPNG::Color.rgba(
            Effect.clamp(ChunkyPNG::Color.r(pixel) + brightness_adjust),
            Effect.clamp(ChunkyPNG::Color.g(pixel) + brightness_adjust),
            Effect.clamp(ChunkyPNG::Color.b(pixel) + brightness_adjust),
            ChunkyPNG::Color.a(pixel)
          )
        end
      end

      # Adjusts the contrast of a color by changing its [R, G, B] components
      # by a given value.
      #
      # Copyright (c) 2010, Ryan LeFevre
      # http://www.camanjs.com
      #
      # @param [Sass::Script::Number] adjust Contrast value as a float,
      #   above 0.0.
      # @return {Effect} A command which applies the contrast to the canvas.
      def contrast(adjust = nil)
        Compass::Magick::Utils.assert_type 'adjust', adjust, Sass::Script::Number
        contrast_adjust = (1.0 + Compass::Magick::Utils.value_of(adjust, 1.0, 0.5))
        Effect.new do |pixel|
          ChunkyPNG::Color.rgba(
            Effect.clamp(((ChunkyPNG::Color.r(pixel) / 255.0 - 0.5) * contrast_adjust + 0.5) * 255),
            Effect.clamp(((ChunkyPNG::Color.g(pixel) / 255.0 - 0.5) * contrast_adjust + 0.5) * 255),
            Effect.clamp(((ChunkyPNG::Color.b(pixel) / 255.0 - 0.5) * contrast_adjust + 0.5) * 255),
            ChunkyPNG::Color.a(pixel)
          )
        end
      end

      # Adjusts the saturation of a color by changing its [R, G, B]
      # components matching the highest intensity.
      #
      # Copyright (c) 2010, Ryan LeFevre
      # http://www.camanjs.com
      #
      # @param [Sass::Script::Number] adjust Saturation value as a float,
      #   above 0.0.
      # @return {Effect} A command which applies the saturation to the canvas.
      def saturation(adjust = nil)
        Compass::Magick::Utils.assert_type 'adjust', adjust, Sass::Script::Number
        saturation_adjust = Compass::Magick::Utils.value_of(adjust, 1.0, 0.5) * -1;
        Effect.new do |pixel|
          r   = ChunkyPNG::Color.r(pixel)
          g   = ChunkyPNG::Color.g(pixel)
          b   = ChunkyPNG::Color.b(pixel)
          max = [r, g, b].max
          r   = r + (max - r) * saturation_adjust unless r == max
          g   = g + (max - g) * saturation_adjust unless g == max
          b   = b + (max - b) * saturation_adjust unless b == max
          ChunkyPNG::Color.rgba(Effect.clamp(r), Effect.clamp(g), Effect.clamp(b), ChunkyPNG::Color.a(pixel))
        end
      end

      # Adjusts the vibrance of a color by changing its [R, G, B] components
      # matching the average intensity.
      #
      # Copyright (c) 2010, Ryan LeFevre
      # http://www.camanjs.com
      #
      # @param [Sass::Script::Number] adjust Vibrance value as a float,
      #   above 0.0.
      # @return {Effect} A command which applies the vibrance to the canvas.
      def vibrance(adjust = nil)
        Compass::Magick::Utils.assert_type 'adjust', adjust, Sass::Script::Number
        vibrance_adjust = Compass::Magick::Utils.value_of(adjust, 1.0, 0.5) * -1;
        Effect.new do |pixel|
          r       = ChunkyPNG::Color.r(pixel)
          g       = ChunkyPNG::Color.g(pixel)
          b       = ChunkyPNG::Color.b(pixel)
          max     = [r, g, b].max
          average = (r + g + b) / 3.0
          amount  = (((max - average).abs * 2.0) * vibrance_adjust) / 100.0
          r       = r + (max - r) * amount unless r == max
          g       = g + (max - g) * amount unless g == max
          b       = b + (max - b) * amount unless b == max
          ChunkyPNG::Color.rgba(Effect.clamp(r), Effect.clamp(g), Effect.clamp(b), ChunkyPNG::Color.a(pixel))
        end
      end
    end
  end
end
