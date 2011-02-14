module Compass::Magick::Functions::Grayscale
  def magick_grayscale(*args)
    Compass::Magick::Commands::Grayscale.new *args
  end
end
