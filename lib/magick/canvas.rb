require 'base64'

module Compass::Magick
  # A Canvas class that uses ChunkyPNG::Canvas internally to represent the
  # image as a matrix of pixels.
  #
  # The image is constructed from a given width and height on a transparent
  # background. The list of commands is executed in order and the resulting
  # image is returned as a Base64 encoded PNG-24 Data URI.
  #
  # @see http://rdoc.info/gems/chunky_png/0.12.0/ChunkyPNG/Canvas
  # @example
  #
  #     background: transparent magick-canvas(320, 200);
  class Canvas < Sass::Script::Funcall
    include Compass::Magick::Utils

    # Initializes a new Canvas instance.
    #
    # @param [Integer] width The width of the Canvas.
    # @param [Integer] height The height of the Canvas.
    # @param [Array<Compass::Magick::Command>] commands The list of commands
    #   to execute on the Canvas instance.
    # @return [String] A Base64 encoded PNG-24 Data URI for the generated
    #   image.
    def initialize(width, height, *commands)
      assert_type 'width',  width,  Sass::Script::Number
      assert_type 'height', height, Sass::Script::Number
      super('magick-canvas', [width, height] + commands)
      @image = ChunkyPNG::Canvas.new(width.value, height.value)
    end

    # Serialize the Canvas image as a Base64 encoded PNG-24 Data URI.
    def to_data_uri
      data = Base64.encode64(@image.to_blob).gsub("\n", '')
      Sass::Script::String.new("url('data:image/png;base64,#{data}')")
    end

    alias :to_s :to_data_uri
  end
end
