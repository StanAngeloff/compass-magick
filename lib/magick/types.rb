module Compass::Magick
  # Abstract Type class.
  #
  # Defines the methods all Type instances must implement.
  #
  # @abstract
  # @see Compass::Magick::Types
  class Type
    # Generates a {Compass::Magick::Canvas} object.
    #
    # @abstract
    # @param [Sass::Script::Number] width The width of the Canvas.
    # @param [Sass::Script::Number] height The height of the Canvas.
    # @return [Compass::Magick::Canvas] The Canvas object which is composed
    #   on top of the original image.
    def to_canvas(width, height)
      raise AbstractMethod.new("#{self.class} must implement 'to_canvas'")
    end
  end

  # The Types module includes all fill types available in Compass Magick.
  #
  # Types generate {Compass::Magick::Canvas} objects with the given options,
  # e.g., a solid color or a linear gradient. The resulting Canvas is then
  # composed on top of the original image using alpha blending.
  #
  # This can be a slow operation, but it reduces the amount of work required
  # and abstracts the drawing logic in four easy steps - draw B/W shape, fill
  # rectangle, mask and compose on top of original image.
  #
  # @see Compass::Magick::Types::Solid
  # @see Compass::Magick::Types::Gradients
  module Types; end
end

require 'magick/types/solid'
require 'magick/types/gradients'
