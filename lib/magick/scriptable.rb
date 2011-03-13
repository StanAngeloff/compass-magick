module Compass::Magick
  # Common Sass node methods module.
  #
  # In order to export certain classes for Sass, they must implement a set of
  # methods. This module provides a no-op implementation.
  module Scriptable
    # Sets the options hash for this node.
    #
    # @param [{Symbol => Object}] options The options hash.
    def options=(options)
      @options = options
    end

    # @return [{Symbol => Object}] The options hash.
    attr_reader :options

    # Sets the context for this node.
    #
    # @param [Symbol] context
    # @see #context
    def context=(context)
      @context = context
    end

    # The context in which this node was parsed, which determines how some
    # operations are performed.
    #
    # @return [Symbol]
    attr_reader :context
  end
end
