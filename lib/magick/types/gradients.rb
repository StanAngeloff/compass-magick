module Compass::Magick
  module Types
    # The Gradients module defines all available Compass Magick gradient
    # fills.
    #
    # At present, we only support point-to-point linear fill at an angle. The
    # two points are determined automatically such as the center of the
    # linear gradient is the center if the given region as well.
    module Gradients
      # A type that is used when constructing gradients to have precise
      # control over color stops.
      class ColorStop < Type
        include Utils

        # Initializes a new ColorStop instance.
        #
        # @param [Sass::Script::Number] offset The color stop offset, 0-100.
        # @param [Sass::Script::Color] color The color at the offset.
        def initialize(offset, color)
          assert_type 'offset', offset, Sass::Script::Number
          assert_type 'color',  color,  Sass::Script::Color
          @offset = offset
          @color  = color
        end

        # @return [Sass::Script::Number] The color stop offset, 0-100.
        attr_reader :offset

        # @return [Sass::Script::Color] The color at the offset.
        attr_reader :color
      end

      # A type that generates a {Canvas} from a region filled using
      # point-to-point linear gradient at an angle.
      #
      # @example
      #
      #     Linear.new(
      #       Sass::Script::Number.new(45), [
      #         ColorStop.new(Sass::Script::Number.new(0),   Sass::Script::Color.new([255,   0,   0])),
      #         ColorStop.new(Sass::Script::Number.new(50),  Sass::Script::Color.new([  0, 255,   0])),
      #         ColorStop.new(Sass::Script::Number.new(100), Sass::Script::Color.new([  0,   0, 255]))
      #       ]
      #     )
      class Linear < Type
        include Utils

        # Initializes a new Linear instance.
        #
        # @param [Sass::Script::Number] angle The angle of the linear
        #   gradient. The two points that form the point-to-point linear fill
        #   are determined based on this value.
        # @param [Array<ColorStop>] stops A list of color stops to interpolate
        #   between.
        def initialize(angle, stops)
          assert_type 'angle', angle, Sass::Script::Number
          assert_type 'stops', stops, Array
          stops.each_with_index { |stop, index| assert_type "stop[#{index}]", stop, ColorStop }
          @angle = angle
          @stops = cache_stops(stops)
        end

        # @return [Sass::Script::Number] angle The angle of the linear
        #   gradient.
        attr_reader :angle

        # @return [Array<ColorStop>] A list of color stops to interpolate
        #   between.
        attr_reader :stops

        def to_canvas(width, height)
          assert_type 'width',  width,  Sass::Script::Number
          assert_type 'height', height, Sass::Script::Number
          canvas = Canvas.new(width, height)
          point_center    = Point.new(canvas.width  / 2,  canvas.height  / 2)
          length_diagonal = Math.sqrt(canvas.width ** 2 + canvas.height ** 2);
          segments_rectangle = [
            [Point.new(0, 0),                                Point.new(canvas.width - 1, 0)],
            [Point.new(canvas.width - 1, 0),                 Point.new(canvas.width - 1, canvas.height - 1)],
            [Point.new(canvas.width - 1, canvas.height - 1), Point.new(0, canvas.height - 1)],
            [Point.new(0, canvas.height - 1),                Point.new(0, 0)]
          ]
          point_start  = nil
          point_finish = nil
          [-1, 1].each do |direction|
            segment = [
              Point.new(point_center.x, point_center.y),
              Point.new(point_center.x + direction * length_diagonal * Math.cos(@angle.value * Math::PI / 180), point_center.y + direction * length_diagonal * Math.sin(@angle.value * Math::PI / 180))
            ];
            segments_rectangle.each do |edge|
              point = intersect(segment, edge)
              if point
                point_start  ||= point if direction == -1
                point_finish ||= point if direction ==  1
              end
            end
          end
          # Michael Madsen & dash-tom-bang
          # http://stackoverflow.com/questions/2869785/point-to-point-linear-gradient#answer-2870275
          vector_gradient   = [point_finish.x - point_start.x, point_finish.y - point_start.y]
          length_gradient   = Math.sqrt(vector_gradient[0] * vector_gradient[0] + vector_gradient[1] * vector_gradient[1])
          vector_normalized = [vector_gradient[0] * (1 / length_gradient), vector_gradient[1] * (1 / length_gradient)]
          (0...canvas.height).each do |y|
            (0...canvas.width).each do |x|
              result_normalized = (vector_normalized[0] * (x - point_start.x) + vector_normalized[1] * (y - point_start.y)) / length_gradient
              canvas.set_pixel(x, y, interpolate(100 * (result_normalized < 0 ? 0 : result_normalized > 1 ? 1 : result_normalized)))
            end
          end
          canvas
        end

        private

        def cache_stops(stops)
          @stops = stops.sort { |left, right| left.offset.value <=> right.offset.value }.map do |stop|
            {
              :color  => to_chunky_color(stop.color),
              :offset => stop.offset.value,
              :rgba   => [
                stop.color.red,
                stop.color.green,
                stop.color.blue,
                stop.color.alpha * 255
              ]
            }
          end
        end

        def intersect(segment1, segment2)
          # Andre LeMothe
          # http://www.amazon.com/dp/0672323699/
          # http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect#answer-1968345
          s1_x = segment1[1].x - segment1[0].x
          s1_y = segment1[1].y - segment1[0].y
          s2_x = segment2[1].x - segment2[0].x
          s2_y = segment2[1].y - segment2[0].y
          s    = (- s1_y * (segment1[0].x - segment2[0].x) + s1_x * (segment1[0].y - segment2[0].y)) / (- s2_x * s1_y + s1_x * s2_y)
          t    = (  s2_x * (segment1[0].y - segment2[0].y) - s2_y * (segment1[0].x - segment2[0].x)) / (- s2_x * s1_y + s1_x * s2_y)
          if s >= 0 && s <= 1 && t >= 0 && t <= 1
            Point.new(
              segment1[0].x + (t * s1_x),
              segment1[0].y + (t * s1_y)
            )
          else
            false
          end
        end

        def interpolate(offset)
          start  = nil
          finish = nil
          @stops.each do |stop|
            if offset >= stop[:offset]
              if start
                start = stop unless start[:offset] > stop[:offset]
              else
                start = stop
              end
            end
            if offset <= stop[:offset]
              if finish
                finish = stop unless finish[:offset] < stop[:offset]
              else
                finish = stop
              end
            end
          end
          return @stops[0][:color]  unless start
          return @stops[-1][:color] unless finish
          return finish[:color]     if     start[:offset] == finish[:offset]
          rgba = []
          # walkytalky
          # http://stackoverflow.com/questions/3017019/non-linear-color-interpolation#answer-3030245
          for i in (0..3)
            rgba[i] = (start[:rgba][i] + (offset - start[:offset]) * (finish[:rgba][i] - start[:rgba][i]) / (finish[:offset] - start[:offset])).to_i
          end
          ChunkyPNG::Color.rgba(*rgba)
        end
      end
    end
  end
end
