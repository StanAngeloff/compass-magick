module Compass::Magick::Functions::Erase
  def magick_erase(*args)
    Compass::Magick::Commands::Erase.new *args
  end
end
