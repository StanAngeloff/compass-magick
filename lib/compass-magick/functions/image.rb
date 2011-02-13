module Compass::Magick::Functions::Image
  def magick_image(*args)
    image = Compass::Magick::Commands::Image.new *args
    image.context = self
    image.options = options
    image.to_s
  end
end
