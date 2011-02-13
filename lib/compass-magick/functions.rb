module Compass::Magick::Functions; end

require 'compass-magick/functions/corners'
require 'compass-magick/functions/erase'
require 'compass-magick/functions/gradients'
require 'compass-magick/functions/image'

module Sass::Script::Functions
  include Compass::Magick::Functions::Corners
  include Compass::Magick::Functions::Erase
  include Compass::Magick::Functions::Gradients
  include Compass::Magick::Functions::Image
end
