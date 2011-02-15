module Compass::Magick::Functions::Colors
  def magick_linear_gradient(*args)
    Compass::Magick::Commands::Colors::LinearGradient.new *args
  end

  def magick_color_stop(*args)
    Compass::Magick::Commands::Colors::Stop.new *args
  end
end
