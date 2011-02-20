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
    include Compass::Magick::Utils

    # Initializes a new Canvas instance.
    #
    # @param [Sass::Script::Number] width The width of the Canvas.
    # @param [Sass::Script::Number] height The height of the Canvas.
    # @param [Array<Compass::Magick::Command>] commands The list of commands
    #   to execute on the Canvas instance.
    def initialize(width, height, *commands)
      assert_type 'width',  width,  Sass::Script::Number
      assert_type 'height', height, Sass::Script::Number
      super(width.value, height.value)
      @options = []
    end

    # Sets the options hash for this node.
    #
    # @param [{Symbol => Object}] options The options hash.
    def options=(options)
      @options = options
    end

    # Serializes the Canvas as a Base64 encoded PNG-24 Data URI.
    #
    # @return [String] A Base64 encoded PNG-24 Data URI for the generated
    #   image.
    def to_data_uri
      data = Base64.encode64(to_blob).gsub("\n", '')
      Sass::Script::String.new("url('data:image/png;base64,#{data}')")
    end

    alias :to_s :to_data_uri
  end
end
