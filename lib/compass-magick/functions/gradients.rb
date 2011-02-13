module Compass::Magick::Functions::Gradients
  def magick_linear_gradient(*args)
    Compass::Magick::Commands::Gradients::Linear.new *args
  end

  def magick_color_stop(*args)
    Compass::Magick::Commands::Gradients::ColorStop.new *args
  end
end
