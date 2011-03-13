module Compass::Magick
  module Functions
    # Methods for performing various visual effects on a
    # {Compass::Magick::Canvas}, e.g., fade, desaturate, etc.
    module Effects
      extend self

      # Lowers the intensity of a color, by lowering its alpha by a given
      # factor.
      #
      # @param [Sass::Script::Number] factor Fade factor as a float between
      #   0.0 and 1.0.
      # @return {Effect} A command which applies the fade to the canvas.
      def fade(factor = nil)
        Compass::Magick::Utils.assert_type 'factor', factor, Sass::Script::Number
        fade_factor = 255 - (255 * Compass::Magick::Utils.value_of(factor, 1.0, 0.5)).to_i
        Effect.new { |pixel| ChunkyPNG::Color.fade(pixel, fade_factor) }
      end
    end
  end
end
