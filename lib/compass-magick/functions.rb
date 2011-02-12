module Compass::Magick::Functions; end

require 'compass-magick/functions/image'
require 'compass-magick/functions/erase'
require 'compass-magick/functions/gradients'

module Sass::Script::Functions
  include Compass::Magick::Functions::Image
  include Compass::Magick::Functions::Erase
  include Compass::Magick::Functions::Gradients
end
