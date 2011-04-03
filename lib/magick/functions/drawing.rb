module Compass::Magick
  module Functions
    # Methods for drawing on a {Compass::Magick::Canvas}.
    module Drawing
      # Fills the {Canvas} region with the given {Compass::Magick::Type}.
      #
      # @param [Object] type The type of fill to apply. Supported:
      #   * Sass::Script::Color
      #   * Sass::Script::String
      #   * {Compass::Magick::Types::Solid}
      #   * {Compass::Magick::Types::Gradients::Linear}
      # @param [Sass::Script::Number] x1 The left coordinate of the fill.
      # @param [Sass::Script::Number] y1 The top coordinate of the fill.
      # @param [Sass::Script::Number] x2 The right coordinate of the fill.
      # @param [Sass::Script::Number] y2 The bottom coordinate of the fill.
      # @return {Command} A command which applies the fill on the canvas.
      def magick_fill(type, x1 = nil, y1 = nil, x2 = nil, y2 = nil)
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
          overlay   = Compass::Magick::Utils.to_canvas(type, width, height)
          canvas.compose(overlay, canvas_x1, canvas_y1)
        end
      end

      # Draws a circle on the {Canvas} with the given fill
      # {Compass::Magick::Type}.
      #
      # The X and Y coordinates are **not** the center of the circle, but
      # rather the coordinates at which the circle is composed on top of the
      # {Canvas}. E.g., <tt>100%, 100%</tt> would put the circle at the
      # bottom-right corner of the {Canvas}.
      #
      # @param [Object] type The type of fill to apply. Supported:
      #   * Sass::Script::Color
      #   * Sass::Script::String
      #   * {Compass::Magick::Types::Solid}
      #   * {Compass::Magick::Types::Gradients::Linear}
      # @param [Sass::Script::Number] radius The radius of the circle.
      # @param [Sass::Script::Number] x The composite X coordinate of the
      #   circle.
      # @param [Sass::Script::Number] y The composite Y coordinate of the
      #   circle.
      # @param [Sass::Script::Number] feather The feater value determines the
      #   anti-aliasing the circle will get, defaults to <tt>1</tt>.
      # @return {Command} A command(-set) which composes a circle on the
      #   canvas.
      def magick_circle(type, radius, compose_x, compose_y, feather = nil)
        Compass::Magick::Utils.assert_type 'radius',   radius,   Sass::Script::Number
        Compass::Magick::Utils.assert_type 'feather',  feather,  Sass::Script::Number
        Command.new do |canvas|
          circle_radius  = Compass::Magick::Utils.value_of(radius,  [canvas.width, canvas.height].min, 1)
          circle_feather = Compass::Magick::Utils.value_of(feather, [canvas.width, canvas.height].min, 1).to_f
          mask    = Compass::Magick::Shapes.circle(circle_radius, circle_radius, circle_feather)
          overlay = Compass::Magick::Utils.to_canvas(type, Sass::Script::Number.new(circle_radius), Sass::Script::Number.new(circle_radius))
          Compass::Magick::Canvas.new(canvas, magick_compose(Compass::Magick::Canvas.new(overlay, magick_mask(mask)), compose_x, compose_y))
        end
      end

      # Draws a (rounded) border around the {Canvas} with the given width and
      # fill {Compass::Magick::Type}.
      #
      # When <tt>width</tt> is not given, the border fills the entire image.
      #
      # @param [Object] type The type of fill to apply. Supported:
      #   * Sass::Script::Color
      #   * Sass::Script::String
      #   * {Compass::Magick::Types::Solid}
      #   * {Compass::Magick::Types::Gradients::Linear}
      # @param [Sass::Script::Number] radius The border radius.
      # @param [Sass::Script::Number] will The border width, defaults to
      #   filling the entire image.
      # @param [Sass::Script::Bool] top_left Controls the top-left border
      #   radius effect (default <tt>true</tt>)
      # @param [Sass::Script::Bool] top_right Controls the top-right border
      #   radius effect (default <tt>true</tt>)
      # @param [Sass::Script::Bool] bottom_right Controls the bottom-right
      #   border radius effect (default <tt>true</tt>)
      # @param [Sass::Script::Bool] bottom_left Controls the bottom-left
      #   border radius effect (default <tt>true</tt>)
      # @return {Command} A command(-set) which composes the border on the
      #   canvas.
      def magick_border(type, radius = nil, width = nil, top_left = nil, top_right = nil, bottom_right = nil, bottom_left = nil)
        Compass::Magick::Utils.assert_type 'radius',       radius,       Sass::Script::Number
        Compass::Magick::Utils.assert_type 'width',        width,        Sass::Script::Number
        Compass::Magick::Utils.assert_type 'top_left',     top_left,     Sass::Script::Bool
        Compass::Magick::Utils.assert_type 'top_right',    top_right,    Sass::Script::Bool
        Compass::Magick::Utils.assert_type 'bottom_left',  bottom_left,  Sass::Script::Bool
        Compass::Magick::Utils.assert_type 'bottom_right', bottom_right, Sass::Script::Bool
        Command.new do |canvas|
          max = [canvas.width, canvas.height].max
          min = [canvas.width, canvas.height].min
          border_width  = Compass::Magick::Utils.value_of(width,  max, max)
          border_radius = Compass::Magick::Utils.value_of(radius, min, 10)
          border_top_left     = (top_left.nil?     || top_left.value)
          border_top_right    = (top_right.nil?    || top_right.value)
          border_bottom_right = (bottom_right.nil? || bottom_right.value)
          border_bottom_left  = (bottom_left.nil?  || bottom_left.value)
          right_x  = canvas.width  - border_radius
          bottom_y = canvas.height - border_radius
          mask = ChunkyPNG::Canvas.new(canvas.width, canvas.height, ChunkyPNG::Color.rgba(0, 0, 0, 0))
          for y in 0...canvas.height
            for x in 0...canvas.width
              unless (border_top_left     && (y < border_radius && x < border_radius)) ||
                     (border_top_right    && (y < border_radius && x > right_x))       ||
                     (border_bottom_right && (y > bottom_y && x > right_x))            ||
                     (border_bottom_left  && (y > bottom_y && x < border_radius))
                if y < border_width || y >= canvas.height - border_width ||
                   x < border_width || x >= canvas.width - border_width
                  mask.set_pixel(x, y, ChunkyPNG::Color::WHITE)
                end
              end
            end
          end
          if border_radius > 0
            radius_mask = Compass::Magick::Shapes.circle(border_radius * 2, border_width)
            if border_top_left
              mask.compose!(radius_mask.crop(0, 0, border_radius, border_radius), 0, 0)
            end
            if border_top_right
              mask.compose!(radius_mask.crop(border_radius, 0, border_radius, border_radius), mask.width - border_radius, 0)
            end
            if border_bottom_right
              mask.compose!(radius_mask.crop(border_radius, border_radius, border_radius, border_radius), mask.width - border_radius, mask.height - border_radius)
            end
            if border_bottom_left
              mask.compose!(radius_mask.crop(0, border_radius, border_radius, border_radius), 0, mask.height - border_radius)
            end
          end
          overlay = Compass::Magick::Utils.to_canvas(type, Sass::Script::Number.new(canvas.width), Sass::Script::Number.new(canvas.height))
          Compass::Magick::Canvas.new(canvas, magick_compose(Compass::Magick::Canvas.new(overlay, magick_mask(mask))))
        end
      end
    end
  end
end
