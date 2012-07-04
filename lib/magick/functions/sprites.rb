module Compass::Magick
  module Functions
    # Methods for generating sprites from on a {Compass::Magick::Canvas}.
    module Sprites
      # Writes the canvas to a file, encoded as a PNG image. The output is
      # optimized for best compression.
      #
      # @param [Sass::Script::String] basename The PNG image basename. The
      #   generated file is saved in the configured images directory with a
      #   .png extension. Directory names are allowed and can be used to
      #   group a set of objects together.
      # @param [Canvas] canvas The Canvas object to write.
      # @return [Sass::Script::String] A URL to the generated sprite image.
      #   (Depending on your configuration) The path is relative and has the
      #   cache buster appended after the file extension.
      def magick_sprite(basename, canvas)
        Compass::Magick::Utils.assert_type 'basename', basename, Sass::Script::String
        Compass::Magick::Utils.assert_type 'canvas',   canvas,   ChunkyPNG::Canvas
        extension = '.png'
        filename  = basename.value.chomp(extension) + extension
        filepath  = File.join(Compass.configuration.generated_images_path, filename)
        FileUtils.mkpath(File.dirname(filepath))
        canvas.save(filepath, :best_compression)
        generated_image_url(Sass::Script::String.new(filename))
      end
    end
  end
end
