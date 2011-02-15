module Compass::Magick::Functions::Colors
  def magick_linear_gradient(*args)
    Compass::Magick::Types::Colors::LinearGradient.new *args
  end

  def magick_color_stop(*args)
    Compass::Magick::Types::Colors::Stop.new *args
  end
end
