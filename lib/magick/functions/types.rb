module Compass::Magick
  module Functions
    # Methods for creating new {Compass::Magick::Types}.
    module Types
      # Creates a new {Compass::Magick::Types::Solid} instance.
      #
      # @param [Sass::Script::Color] color The solid background color.
      # @return [Compass::Magick::Types::Solid] A type that generates a
      #   {Canvas} from a region filled with a solid color.
      def magick_solid(color)
        Compass::Magick::Types::Solid.new(color)
      end

      # Creates a new {Compass::Magick::Types::ColorStop} instance.
      #
      # @param [Sass::Script::Number] offset The color stop offset, 0-100.
      # @param [Sass::Script::Color] color The color at the offset.
      # @return [Compass::Magick::Types::ColorStop] A type that is used when
      #   constructing gradients to control color stops.
      def magick_color_stop(offset, color)
        Compass::Magick::Types::Gradients::ColorStop.new(offset, color)
      end

      # Creates a new {Compass::Magick::Types::Gradients::Linear} instance.
      #
      # @overload magick_linear_gradient(angle, stops)
      #   @param [Sass::Script::Number] angle The angle of the linear
      #     gradient.
      #   @param [Array<Compass::Magick::Types::Gradients::ColorStop>] stops
      #     A list of color stops to interpolate between.
      # @overload magick_linear_gradient(stops)
      #   @param [Array<Compass::Magick::Types::Gradients::ColorStop>] stops
      #     A list of color stops to interpolate between.
      # @return [Compass::Magick::Types::Gradients::Linear] A type that
      #   generates a {Canvas} from a region filled using point-to-point
      #   linear gradient at an angle.
      def magick_linear_gradient(*args)
        angle   = args.shift if args[0].kind_of?(Sass::Script::Number)
        angle ||= Sass::Script::Number.new(90)
        stops   = []
        last_offset = 0
        args.each_with_index do |stop, index|
          if stop.kind_of?(Sass::Script::Color)
            if index > 0
              if index == args.length - 1
                offset = 100
              else
                next_index  = 0
                next_offset = nil
                args.slice(index, args.length).each do |next_stop|
                  next_index = next_index + 1
                  if next_stop.kind_of?(Compass::Magick::Types::Gradients::ColorStop)
                    next_offset = next_stop.offset.value
                    break
                  end
                end
                next_offset ||= 100
                offset = last_offset + (next_offset - last_offset) / next_index
              end
            else
              offset = 0
            end
            stops.push(Compass::Magick::Types::Gradients::ColorStop.new(Sass::Script::Number.new(offset), stop))
            last_offset = offset
          else
            stops.push(stop)
            last_offset = stop.offset.value if stop.respond_to?(:offset)
          end
        end
        Compass::Magick::Types::Gradients::Linear.new(angle, stops)
      end
    end
  end
end
