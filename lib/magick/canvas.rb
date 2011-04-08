require 'base64'

module Compass::Magick
  # A Canvas class that inherits ChunkyPNG::Canvas to represent the image as
  # a matrix of pixels.
  #
  # The canvas is constructed from a given width and height on a transparent
  # background. The list of commands is executed in order and the resulting
  # image is returned as a Base64 encoded PNG-24 Data URI.
  #
  # @see http://rdoc.info/gems/chunky_png/0.12.0/ChunkyPNG/Canvas
  # @example
  #
  #     Canvas.new(320, 240).to_data_uri
  class Canvas < ChunkyPNG::Canvas
    include Scriptable
    include Utils

    # Initializes a new Canvas instance.
    #
    # @overload initialize(canvas, *commands)
    #   @param [Canvas] canvas Copy image from another Canvas object.
    #   @param [Array<Command>] commands The list of commands to execute on
    #     new Canvas instance.
    # @overload initialize(data, *commands)
    #   @param [Sass::Script::String] data A Base64 encoded Data URL
    #     containing the image.
    #   @param [Array<Command>] commands The list of commands to execute on
    #     the Canvas instance.
    # @overload initialize(url, *commands)
    #   @param [Sass::Script::String] url The URL to the image, relative to
    #     the stylesheet.
    #   @param [Array<Command>] commands The list of commands to execute on
    #     the Canvas instance.
    # @overload initialize(path, *commands)
    #   @param [Sass::Script::String] path The path to the image, relative to
    #     the configured <tt>images_dir</tt>.
    #   @param [Array<Command>] commands The list of commands to execute on
    #     the Canvas instance.
    # @overload initialize(width, height, *commands)
    #   @param [Sass::Script::Number] width The width of the new transparent
    #     Canvas.
    #   @param [Sass::Script::Number] height The height of the new transparent
    #     Canvas.
    #   @param [Array<Command>] commands The list of commands to execute on the
    #     Canvas instance.
    def initialize(*commands)
      from_any(commands)
      list = []
      commands.each do |command|
        if command.kind_of?(Sass::Script::List)
          list.push(command.value)
        else
          list.push(command)
        end
      end
      list.flatten!
      list.each_with_index { |command, index| assert_type "command[#{index}]", command, Command }
      list.each do |command|
        result = command.block.call(self)
        inherit result, false if result.kind_of?(ChunkyPNG::Canvas) unless result == self
      end
    end

    # Serializes the Canvas as a Base64 encoded PNG-24 Data URI.
    #
    # @return [String] A Base64 encoded PNG-24 Data URI for the generated
    #   image.
    def to_data_uri(options = {})
      data = Base64.encode64(to_blob).gsub("\n", '')
      "url('data:image/png;base64,#{data}')"
    end

    alias :to_s :to_data_uri

    private

    def inherit(canvas, copy = true)
      @width  = canvas.width
      @height = canvas.height
      @pixels = (copy ? canvas.pixels.dup : canvas.pixels)
      self
    end

    def from_any(args)
      source = args.shift
      if source.kind_of?(ChunkyPNG::Canvas)
        inherit source
      elsif source.kind_of?(Sass::Script::Number)
        inherit ChunkyPNG::Canvas.new(source.value, args.shift.value), false
      elsif source.kind_of?(Sass::Script::String)
        if source.value.include?('url(')
          if source.value.include?('base64,')
            encoded  = source.value.match(/base64,([a-zA-Z0-9+\/=]+)/)[1]
            blob     = Base64.decode64(encoded)
            canvas   = ChunkyPNG::Canvas.from_blob(blob)
          else
            filename = source.value.gsub(/^url\(['"]?|["']?\)$/, '')
            path     = File.join(Compass.configuration.css_path, filename.split('?').shift())
            canvas   = ChunkyPNG::Canvas.from_file(path)
          end
        else
          path   = File.join(Compass.configuration.images_path, source.value.split('?').shift())
          canvas = ChunkyPNG::Canvas.from_file(path)
        end
        inherit canvas, false
      else
        raise NotSupported.new("Canvas.new(..) expected argument of type " +
          "Compass::Magick::Canvas, Sass::Script::Number or Sass::Script::String " +
          "got #{source.class}(#{source.inspect}) instead")
      end
    end
  end
end
