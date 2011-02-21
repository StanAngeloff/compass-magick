module Compass::Magick
  # A class that executes a block on a {Canvas} object.
  #
  # When a function is called in a Sass document, it delays its execution
  # until placed within a canvas. To do so, it must store state and return a
  # valid Sass node.
  #
  # @example
  #
  #     Command.new do |canvas|
  #       canvas.rect(0, 0, canvas.width - 1, canvas.height - 1, ChunkyPNG::Color::BLACK)
  #     end
  class Command
    include Utils

    # Initializes a new Command instance.
    #
    # @param [Proc] block The block to execute.
    def initialize(&block)
      @block = block
    end

    # @return [Proc] The block to execute.
    attr_reader :block

    # Sets the options hash for this node.
    #
    # @param [{Symbol => Object}] options The options hash.
    def options=(options)
      @options = options
    end

    # Raises an error if the command is used outside of a {Canvas} object.
    def to_s
      raise NotAllowed.new("#{self.class} cannot be used outside of a Compass::Magick::Canvas object")
    end
  end
end
