module Compass::Magick::Functions::Filters
  def magick_desaturate(*args)
    Compass::Magick::Commands::Filters::Desaturate.new *args
  end
end
