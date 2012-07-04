module Compass::Magick
  module Functions
    # Methods for creating a new {Compass::Magick::Canvas}.
    module Canvas
      # Creates a new {Compass::Magick::Canvas} and execute all
      # commands on the instance.
      #
      # @overload magick_canvas(canvas, *commands)
      #   @param [Canvas] canvas Copy image from another Canvas object.
      #   @param [Array<Command>] commands The list of commands to execute on
      #     new Canvas instance.
      # @overload magick_canvas(data, *commands)
      #   @param [Sass::Script::String] data A Base64 encoded Data URL
      #     containing the image.
      #   @param [Array<Command>] commands The list of commands to execute on
      #     the Canvas instance.
      # @overload magick_canvas(url, *commands)
      #   @param [Sass::Script::String] url The URL to the image, relative to
      #     the stylesheet.
      #   @param [Array<Command>] commands The list of commands to execute on
      #     the Canvas instance.
      # @overload magick_canvas(path, *commands)
      #   @param [Sass::Script::String] path The path to the image, relative
      #     to the configured <tt>generated_images_path</tt> or <tt>images_path</tt>.
      #   @param [Array<Command>] commands The list of commands to execute on
      #     the Canvas instance.
      # @overload magick_canvas(width, height, *commands)
      #   @param [Sass::Script::Number] width The width of the new transparent
      #     Canvas.
      #   @param [Sass::Script::Number] height The height of the new
      #     transparent Canvas.
      #   @param [Array<Command>] commands The list of commands to execute on
      #     the Canvas instance.
      # @return [String] A Base64 encoded PNG-24 Data URI for the generated
      #   image.
      def magick_canvas(*commands)
        Compass::Magick::Canvas.new(*commands)
      end
    end
  end
end
