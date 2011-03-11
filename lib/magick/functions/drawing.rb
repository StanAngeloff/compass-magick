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
        Compass::Magick::Utils.assert_one_of 'magick_fill(..)', type, Sass::Script::Color, Compass::Magick::Type
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
      # Copyright (c) 2003 by Nils Haeck M.Sc. (Simdesign)
      # http://www.simdesign.nl
      #
      # “The [..] DrawDisk routines is optimized quite well but do not claim
      # to be the fastest solution :) It is a floating point precision
      # implementation. Further optimisation would be possible if an
      # integer approach was chosen (but that would also loose
      # functionality).”
      #
      # @param [Object] type The type of fill to apply. Supported:
      #   * Sass::Script::Color
      #   * {Compass::Magick::Types::Solid}
      #   * {Compass::Magick::Types::Gradients::Linear}
      # @param [Sass::Script::Number] x The composite X coordinate of the
      #   circle.
      # @param [Sass::Script::Number] y The composite Y coordinate of the
      #   circle.
      # @param [Sass::Script::Number] radius The radius of the circle.
      # @param [Sass::Script::Number] feather The feater value determines the
      #   anti-aliasing the circle will get, defaults to <tt>1</tt>.
      # @return {Command} A command(-set) which composes a circle on the
      #   canvas.
      def magick_circle(type, compose_x, compose_y, radius, feather = nil)
        Compass::Magick::Utils.assert_one_of 'magick_circle(..)', type, Sass::Script::Color, Compass::Magick::Type
        Compass::Magick::Utils.assert_type 'radius',   radius,   Sass::Script::Number
        Compass::Magick::Utils.assert_type 'feather',  feather,  Sass::Script::Number
        Command.new do |canvas|
          circle_radius  = Compass::Magick::Utils.value_of(radius,  [canvas.width, canvas.height].min, 1)
          circle_feather = Compass::Magick::Utils.value_of(feather, [canvas.width, canvas.height].min, 1).to_f
          circle_half = (circle_radius - 1).to_f / 2
          rpf2 = (circle_half + circle_feather / 2) ** 2
          rmf2 = (circle_half - circle_feather / 2) ** 2
          lx   = [(circle_half - rpf2).floor, 0].max
          ly   = [(circle_half - rpf2).floor, 0].max
          rx   = [(circle_half + rpf2).ceil, circle_radius - 1].min
          ry   = [(circle_half + rpf2).ceil, circle_radius - 1].min
          sqx  = Array.new(rx - lx + 1)
          for x in lx..rx
            sqx[x - lx] = (x - circle_half) ** 2
          end
          mask = ChunkyPNG::Canvas.new(circle_radius, circle_radius, ChunkyPNG::Color.rgba(0, 0, 0, 0))
          for y in ly..ry
            sqy = (y - circle_half) ** 2
            for x in lx..rx
              sqdist = sqy + sqx[x - lx]
              if sqdist < rmf2
                mask.set_pixel(x, y, ChunkyPNG::Color::WHITE)
              else
                if sqdist < rpf2
                  fact = (((circle_half - Math.sqrt(sqdist)) * 2 / circle_feather) * 0.5 + 0.5)
                  mask.set_pixel(x, y, ChunkyPNG::Color.rgba(255, 255, 255, 255 * [0, [fact, 1].min].max))
                end
              end
            end
          end
          overlay = Compass::Magick::Utils.to_canvas(type, Sass::Script::Number.new(circle_radius), Sass::Script::Number.new(circle_radius))
          Compass::Magick::Canvas.new(overlay, magick_mask(mask), magick_compose(canvas, Sass::Script::Bool.new(true), compose_x, compose_y))
        end
      end
    end
  end
end
