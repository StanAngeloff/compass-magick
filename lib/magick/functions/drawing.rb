module Compass::Magick
  module Functions
    # Methods for drawing on a {Compass::Magick::Canvas}.
    module Drawing
      # Fills the {Canvas} region with the given {Compass::Magick::Type}.
      #
      # @param [Object] type The type of fill to apply. Supported:
      #   * Sass::Script::Color
      #   * {Compass::Magick::Types::Solid}
      #   * {Compass::Magick::Types::Gradients::Linear}
      # @param [Integer] x1 The left coordinate of the fill.
      # @param [Integer] y1 The top coordinate of the fill.
      # @param [Integer] x2 The right coordinate of the fill.
      # @param [Integer] y2 The bottom coordinate of the fill.
      # @return {Command} A command which applies the fill on the canvas.
      def magick_fill(type, x1 = nil, y1 = nil, x2 = nil, y2 = nil)
        raise NotSupported.new("magick_fill(..) expected argument of type " +
            "Sass::Script::Color, Compass::Magick::Types::Solid or Compass::Magick::Types::Gradients::Linear " +
            "got #{type.class}(#{type.inspect}) instead") unless
          type.kind_of?(Sass::Script::Color)           ||
          type.kind_of?(Compass::Magick::Types::Solid) ||
          type.kind_of?(Compass::Magick::Types::Gradients::Linear)
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
          width     = Sass::Script::Number.new(canvas_x2 - canvas_x1)
          height    = Sass::Script::Number.new(canvas_y2 - canvas_y1)
          if type.kind_of?(Sass::Script::Color)
            overlay = Compass::Magick::Types::Solid.new(type).to_canvas(width, height)
          elsif type.kind_of?(Compass::Magick::Types::Solid) || type.kind_of?(Compass::Magick::Types::Gradients::Linear)
            overlay = type.to_canvas(width, height)
          end
          canvas.compose(overlay, canvas_x1, canvas_y1)
        end
      end
    end
  end
end
