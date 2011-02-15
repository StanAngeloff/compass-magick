module Compass::Magick::Commands::Filters
  class Grayscale < Compass::Magick::Command
    include Compass::Magick::Util

    def initialize(strength = nil)
      @strength = strength
    end

    def invoke(image)
      image.modulate(1.0, 1.0 - number_value(@strength, 1, 1), 1.0)
    end
  end
end
