module Compass::Magick
  module Functions
    # Methods for creating a new {Compass::Magick::Canvas}.
    module Canvas
      # Creates a new {Compass::Magick::Canvas} and execute all
      # commands on the instance.
      #
      # @param [Sass::Script::Number] width The width of the Canvas.
      # @param [Sass::Script::Number] height The height of the Canvas.
      # @param [Array<Compass::Magick::Command>] commands The list of commands
      #   to execute on the Canvas instance.
      # @return [String] A Base64 encoded PNG-24 Data URI for the generated
      #   image.
      def magick_canvas(*args)
        Compass::Magick::Canvas.new *args
      end
    end
  end
end
