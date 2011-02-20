require 'magick/functions/canvas'
require 'magick/functions/types'

module Compass::Magick
  # The Functions module includes all public Compass Magick functions.
  #
  # @see Compass::Magick::Functions::Canvas
  module Functions
    include Compass::Magick::Functions::Canvas
    include Compass::Magick::Functions::Types
  end
end

# Functions defined in this module are exported for usage in stylesheets
# (.sass and .scss documents).
#
# Compass Magick exports all available {Compass::Magick::Functions functions}.
module Sass::Script::Functions
  include Compass::Magick::Functions
end
