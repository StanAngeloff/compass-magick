module Compass::Magick::Functions::Corners
  def magick_top_left_corner(*args)
    Compass::Magick::Commands::Corners.new ['top-left'], *args
  end

  def magick_top_right_corner(*args)
    Compass::Magick::Commands::Corners.new ['top-right'], *args
  end

  def magick_bottom_left_corner(*args)
    Compass::Magick::Commands::Corners.new ['bottom-left'], *args
  end

  def magick_bottom_right_corner(*args)
    Compass::Magick::Commands::Corners.new ['bottom-right'], *args
  end

  def magick_corners(*args)
    Compass::Magick::Commands::Corners.new ['top-left', 'top-right', 'bottom-left', 'bottom-right'], *args
  end
end
