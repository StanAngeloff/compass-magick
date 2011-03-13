module Compass::Magick
  module Plugins
    # Applies rounded corners around the {Canvas}.
    #
    # @param [Sass::Script::Number] radius The corner radius.
    # @param [Sass::Script::Bool] top_left Controls the top-left corner
    #   radius effect (default <tt>true</tt>)
    # @param [Sass::Script::Bool] top_right Controls the top-right corner
    #   radius effect (default <tt>true</tt>)
    # @param [Sass::Script::Bool] bottom_right Controls the bottom-right
    #   corner radius effect (default <tt>true</tt>)
    # @param [Sass::Script::Bool] bottom_left Controls the bottom-left
    #   corner radius effect (default <tt>true</tt>)
    # @return {Command} A command(-set) which applies the corners on the
    #   canvas.
    def magick_corners(radius, top_left = nil, top_right = nil, bottom_right = nil, bottom_left = nil)
      Command.new do |canvas|
        Canvas.new(canvas, magick_mask(
          magick_canvas(
            Sass::Script::Number.new(canvas.width),
            Sass::Script::Number.new(canvas.height),
              magick_fill(Sass::Script::Color.new([0, 0, 0])),
              magick_border(Sass::Script::Color.new([255, 255, 255]), radius, nil, top_left, top_right, bottom_right, bottom_left)
          )
        ))
      end
    end
  end
end
