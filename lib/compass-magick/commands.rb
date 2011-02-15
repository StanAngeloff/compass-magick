module Compass::Magick
  class Command < Compass::Magick::Type
    def to_s
      puts "(Magick) Command '#{self.class.to_s.gsub('Compass::Magick::Commands::', '')}' not supported in this context, did you forget a comma?"
    end
  end
end

module Compass::Magick::Commands
  require 'compass-magick/commands/border'
  require 'compass-magick/commands/composite'
  require 'compass-magick/commands/corners'
  require 'compass-magick/commands/crop'
  require 'compass-magick/commands/fill'
  require 'compass-magick/commands/grayscale'
  require 'compass-magick/commands/image'
end
