module Compass::Magick::Functions::Gradients
  def magick_linear_gradient(*args)
    Compass::Magick::Commands::Gradients::Linear.new *args
  end
end
