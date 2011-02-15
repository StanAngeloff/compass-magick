module Compass::Magick
  class Command < Sass::Script::Literal
    def invoke(image)
      raise NotImplementedError.new("#{self.class} must implement #invoke")
    end

    def to_s
      puts "(Magick) Using '#{self.class.to_s.gsub('Compass::Magick::Commands::', '')}' outside of 'magick-image', did you forget a comma?"
    end
  end
end

require 'compass-magick/commands/border'
require 'compass-magick/commands/composite'
require 'compass-magick/commands/corners'
require 'compass-magick/commands/crop'
require 'compass-magick/commands/erase'
require 'compass-magick/commands/gradients'
require 'compass-magick/commands/grayscale'
require 'compass-magick/commands/image'
