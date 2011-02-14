module Compass::Magick::Functions::Composite
  def magick_composite(*args)
    Compass::Magick::Commands::Composite.new *args
  end
end
