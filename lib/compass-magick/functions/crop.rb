module Compass::Magick::Functions::Crop
  def magick_crop(*args)
    Compass::Magick::Commands::Crop.new *args
  end
end
