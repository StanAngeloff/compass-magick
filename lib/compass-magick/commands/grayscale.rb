module Compass::Magick::Commands
  class Grayscale < Compass::Magick::Command
    def invoke(image)
      image.quantize(256, Magick::GRAYColorspace, Magick::NoDitherMethod)
    end
  end
end
