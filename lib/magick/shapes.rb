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
    def circle(radius, width, feather = 1.0)
      mask = ChunkyPNG::Canvas.new(radius, radius, ChunkyPNG::Color.rgba(0, 0, 0, 0))
      if radius <= width
        center = (radius - 1) / 2.0
        rpf2   = (center + feather / 2.0) ** 2
        rmf2   = (center - feather / 2.0) ** 2
        lx     = [(center - rpf2).floor, 0].max
        ly     = [(center - rpf2).floor, 0].max
        rx     = [(center + rpf2).ceil, radius - 1].min
        ry     = [(center + rpf2).ceil, radius - 1].min
        sqx    = Array.new(rx - lx + 1)
        for x in lx..rx
          sqx[x - lx] = (x - center) ** 2
        end
        for y in ly..ry
          sqy = (y - center) ** 2
          for x in lx..rx
            sqdist = sqy + sqx[x - lx]
            if sqdist < rmf2
              mask.set_pixel(x, y, ChunkyPNG::Color::WHITE)
            else
              if sqdist < rpf2
                fact = (((center - Math.sqrt(sqdist)) * 2.0 / feather) * 0.5 + 0.5)
                mask.set_pixel(x, y, ChunkyPNG::Color.rgba(255, 255, 255, 255 * [0, [fact, 1].min].max))
              end
            end
          end
        end
      else
        center  = (radius - 1) / 2.0
        inrad   = (center + feather / 2.0) - width
        ropf2   = (center + feather / 2.0) ** 2
        romf2   = (center - feather / 2.0) ** 2
        ripf2   = (inrad  + feather / 2.0) ** 2
        rimf2   = (inrad  - feather / 2.0) ** 2
        lx      = [(center - ropf2).floor, 0].max
        ly      = [(center - ropf2).floor, 0].max
        rx      = [(center + ropf2).ceil, radius - 1].min
        ry      = [(center + ropf2).ceil, radius - 1].min
        feather = width if feather > width
        sqx     = Array.new(rx - lx + 1)
        for x in lx..rx
          sqx[x - lx] = (x - center) ** 2
        end
        for y in ly..ry
          sqy = (y - center) ** 2
          for x in lx..rx
            sqdist = sqy + sqx[x - lx]
            if sqdist >= rimf2
              if sqdist < ropf2
                if sqdist < romf2
                  if sqdist < ripf2
                    fact = (((Math.sqrt(sqdist) - inrad) * 2 / feather) * 0.5 + 0.5)
                    mask.set_pixel(x, y, ChunkyPNG::Color.rgba(255, 255, 255, 255 * [0, [fact, 1].min].max))
                  else
                    mask.set_pixel(x, y, ChunkyPNG::Color::WHITE)
                  end
                else
                  fact = (((center - Math.sqrt(sqdist)) * 2 / feather) * 0.5 + 0.5)
                  mask.set_pixel(x, y, ChunkyPNG::Color.rgba(255, 255, 255, 255 * [0, [fact, 1].min].max))
                end
              end
            end
          end
        end
      end
      mask
    end
  end
end
