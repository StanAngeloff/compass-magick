module Compass::Magick::Functions::Border
  def magick_border(*args)
    Compass::Magick::Commands::Border.new *args
  end
end
