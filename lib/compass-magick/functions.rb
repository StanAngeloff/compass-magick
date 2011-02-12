module Compass::Magick::Functions; end

require 'compass-magick/functions/image'
require 'compass-magick/functions/erase'
require 'compass-magick/functions/gradients'
require 'compass-magick/functions/corners'

module Sass::Script::Functions
  include Compass::Magick::Functions::Image
  include Compass::Magick::Functions::Erase
  include Compass::Magick::Functions::Gradients
  include Compass::Magick::Functions::Corners
end
