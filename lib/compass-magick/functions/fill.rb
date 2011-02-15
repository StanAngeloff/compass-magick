module Compass::Magick::Functions::Fill
  def magick_fill(*args)
    Compass::Magick::Commands::Fill.new *args
  end
end
