module Compass::Magick::Commands::Filters
  class Grayscale < Compass::Magick::Command
    def invoke(image)
      image.modulate(1.0, 0.0, 1.0)
    end
  end
end
