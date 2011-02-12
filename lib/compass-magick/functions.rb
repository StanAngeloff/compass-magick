module Compass::Magick::Functions; end

require 'compass-magick/functions/image'
require 'compass-magick/functions/erase'

module Sass::Script::Functions
  include Compass::Magick::Functions::Image
  include Compass::Magick::Functions::Erase
end
