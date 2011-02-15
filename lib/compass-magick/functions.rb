module Compass::Magick::Functions; end

require 'compass-magick/functions/border'
require 'compass-magick/functions/colors'
require 'compass-magick/functions/composite'
require 'compass-magick/functions/corners'
require 'compass-magick/functions/crop'
require 'compass-magick/functions/fill'
require 'compass-magick/functions/grayscale'
require 'compass-magick/functions/image'

module Sass::Script::Functions
  include Compass::Magick::Functions::Border
  include Compass::Magick::Functions::Colors
  include Compass::Magick::Functions::Composite
  include Compass::Magick::Functions::Corners
  include Compass::Magick::Functions::Crop
  include Compass::Magick::Functions::Fill
  include Compass::Magick::Functions::Grayscale
  include Compass::Magick::Functions::Image
end
