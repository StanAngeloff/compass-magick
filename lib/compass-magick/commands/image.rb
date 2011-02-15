require File.join(Compass.lib_directory, 'compass', 'sass_extensions', 'functions', 'urls')
require 'base64'

module Compass::Magick::Commands
  class Image < Compass::Magick::Command
    include Compass::SassExtensions::Functions::Urls

    def initialize(*args)
      @filename = args.shift if args[0].is_a?(Sass::Script::String)
      @width    = args.shift
      @height   = args.shift
      @format   = args.shift if args[0].is_a?(Sass::Script::String)
      @commands = args
    end

    def to_s
      image = Magick::Image.new(@width.value, @height.value) do
        self.background_color = 'none'
      end
      @commands.each do |command|
        if command.is_a?(Compass::Magick::Command)
          result = command.invoke(image)
          image  = result if result.is_a?(Magick::Image)
        else
          puts "(Magick) Unsupported operation: '#{command.class.to_s.gsub('Compass::Magick::', '')}'"
        end
      end
      if @filename.nil?
        blob = image.to_blob do
          self.format = (@format ? @format.value.upcase : 'PNG32')
        end
        Sass::Script::String.new("url('data:image/#{ image.format.downcase.gsub /\d+/, '' };base64,#{ Base64.encode64(blob).gsub("\n", '') }')")
      else
        path = File.join(Compass.configuration.images_path, @filename.value.split('?').shift());
        FileUtils.mkpath File.dirname(path)
        image.write(path) do
          self.format = (@format ? @format.value.upcase : 'PNG32')
        end
        image_url(@filename)
      end
    end
  end
end
