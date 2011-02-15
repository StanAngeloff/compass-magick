module Compass::Magick::Functions::Filters
  def magick_grayscale(*args)
    Compass::Magick::Commands::Filters::Grayscale.new *args
  end
end
