module Compass::Magick
  class Type < Sass::Script::Literal
    def invoke(*args)
      raise NotImplementedError.new("#{self.class} must implement #invoke")
    end

    def to_s
      puts "(Magick) Type '#{self.class.to_s.gsub('Compass::Magick::Types::', '')}' not supported in this context, did you forget a comma?"
    end
  end
end

module Compass::Magick::Types
  require 'compass-magick/types/colors'
end
