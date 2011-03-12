module Compass::Magick
  # Drawing methods shared by Compass Magick commands.
  #
  # All of the drawing is done using B/W pixels with varying alpha. These
  # shapes are used to build masks which are then applied to fill
  # {Compass::Magick::Type}s to generate the final canvas.
  module Shapes
    extend self

    # Draws a circle mask.
    #
    # Copyright (c) 2003 by Nils Haeck M.Sc. (Simdesign)
    # http://www.simdesign.nl
    #
    # > The [..] DrawDisk routines is optimized quite well but do not claim
    # > to be the fastest solution :) It is a floating point precision
    # > implementation. Further optimisation would be possible if an
    # > integer approach was chosen (but that would also loose
    # > functionality).
    #
    # @param [Integer] radius The radius of the circle.
    # @param [Float] feather The feater value determines the
    #   anti-aliasing the circle will get, defaults to <tt>1.0</tt>.
    # @return {Canvas} A Canvas with a circle B/W mask.
    def circle(radius, feather = 1.0)
      middle = (radius - 1).to_f / 2
      rpf2   = (middle + feather / 2) ** 2
      rmf2   = (middle - feather / 2) ** 2
      lx     = [(middle - rpf2).floor, 0].max
      ly     = [(middle - rpf2).floor, 0].max
      rx     = [(middle + rpf2).ceil, radius - 1].min
      ry     = [(middle + rpf2).ceil, radius - 1].min
      sqx    = Array.new(rx - lx + 1)
      for x in lx..rx
        sqx[x - lx] = (x - middle) ** 2
      end
      mask = ChunkyPNG::Canvas.new(radius, radius, ChunkyPNG::Color.rgba(0, 0, 0, 0))
      for y in ly..ry
        sqy = (y - middle) ** 2
        for x in lx..rx
          sqdist = sqy + sqx[x - lx]
          if sqdist < rmf2
            mask.set_pixel(x, y, ChunkyPNG::Color::WHITE)
          else
            if sqdist < rpf2
              fact = (((middle - Math.sqrt(sqdist)) * 2 / feather) * 0.5 + 0.5)
              mask.set_pixel(x, y, ChunkyPNG::Color.rgba(255, 255, 255, 255 * [0, [fact, 1].min].max))
            end
          end
        end
      end
      mask
    end
  end
end
