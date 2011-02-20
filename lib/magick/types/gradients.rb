require 'matrix'

module Compass::Magick
  module Types
    # The Gradients module defines all available Compass Magick gradient
    # fills.
    #
    # At present, we only support point-to-point linear fill at an angle. The
    # two points are determined automatically such as the center of the
    # linear gradient is the center if the given region as well.
    module Gradients
      # A type that generates a {Canvas} from a region filled using
      # point-to-point linear gradient at an angle.
      #
      # @example
      #
      #     Linear.new(
      #       Sass::Script::Number.new(45), [
      #         [Sass::Script::Number.new(0),   Sass::Script::Color.new([255,   0,   0])],
      #         [Sass::Script::Number.new(50),  Sass::Script::Color.new([  0, 255,   0])],
      #         [Sass::Script::Number.new(100), Sass::Script::Color.new([  0,   0, 255])]
      #       ]
      #     )
      class Linear < Type
        include Compass::Magick::Utils

        # Initializes a new Linear instance.
        #
        # @param [Sass::Script::Number] angle The angle of the linear
        #   gradient. The two points that form the point-to-point linear fill
        #   are determined based on this value.
        # @param [Array<Array<Sass::Script::Number, Sass::Script::Color>>]
        #   A list of color stops to interpolate between.
        def initialize(angle, stops)
          assert_type 'angle', angle, Sass::Script::Number
          assert_type 'stops', stops, Array
          @angle = angle
          @stops = stops
        end

        # @return [Sass::Script::Number] angle The angle of the linear
        #   gradient.
        attr_reader :angle

        # @return [Array<Array<Sass::Script::Number, Sass::Script::Color>>]
        #   A list of color stops to interpolate between.
        attr_reader :stops

        def to_canvas(width, height)
          assert_type 'width',  width,  Sass::Script::Number
          assert_type 'height', height, Sass::Script::Number
          @stops.each do |stop|
            assert_type 'stop',    stop,    Array
            raise ::ArgumentError.new("(#{self.class}) Color stop expected to be a two-element array, got #{stop.class}(#{stop.inspect}) instead") unless stop.size == 2
            assert_type 'stop[0]', stop[0], Sass::Script::Number
            assert_type 'stop[1]', stop[1], Sass::Script::Color
          end
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
                if point_start
                  point_finish ||= point
                else
                  point_start  ||= point
                end
              end
            end
          end
          # Michael Madsen & dash-tom-bang
          # http://stackoverflow.com/questions/2869785/point-to-point-linear-gradient#answer-2870275
          vector_gradient   = Vector[point_finish.x - point_start.x, point_finish.y - point_start.y]
          length_gradient   = vector_gradient.r
          vector_normalized = vector_gradient * (1 / length_gradient)
          (0...canvas.height).each do |y|
            (0...canvas.width).each do |x|
              result_normalized = vector_normalized.inner_product(Vector[x - point_start.x, y - point_start.y]) / length_gradient
              canvas.set_pixel(x, y, interpolate(100 * [0, [1, result_normalized].min].max))
            end
          end
          canvas
        end

        private

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

        def interpolate(value)
          start  = nil
          finish = nil
          @stops.each do |stop|
            if value >= stop[0].value
              if start
                start = stop unless start[0].value > stop[0].value
              else
                start = stop
              end
            end
            if value <= stop[0].value
              if finish
                finish = stop unless finish[0].value < stop[0].value
              else
                finish = stop
              end
            end
          end
          return to_chunky_color(@stops[0][1])  unless start
          return to_chunky_color(@stops[-1][1]) unless finish
          return to_chunky_color(finish[1])         if start[0] == finish[0]
          start_rgba   = [start[1].red,  start[1].green,  start[1].blue,  255 * start[1].alpha]
          finish_rgba  = [finish[1].red, finish[1].green, finish[1].blue, 255 * finish[1].alpha]
          start_value  = start[0].value
          finish_value = finish[0].value
          rgba         = []
          # walkytalky
          # http://stackoverflow.com/questions/3017019/non-linear-color-interpolation#answer-3030245
          (0..3).each do |i|
            rgba[i] = (start_rgba[i] + (value - start_value) * (finish_rgba[i] - start_rgba[i]) / (finish_value - start_value)).to_i
          end
          ChunkyPNG::Color.rgba(*rgba)
        end
      end
    end
  end
end
