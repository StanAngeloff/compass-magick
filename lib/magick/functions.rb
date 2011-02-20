require 'magick/functions/canvas'
require 'magick/functions/types'
require 'magick/functions/drawing'

module Compass::Magick
  # The Functions module includes all public Compass Magick functions.
  #
  # @see Compass::Magick::Functions::Canvas
  # @see Compass::Magick::Functions::Types
  # @see Compass::Magick::Functions::Drawing
  module Functions
    include Compass::Magick::Functions::Canvas
    include Compass::Magick::Functions::Types
    include Compass::Magick::Functions::Drawing
  end
end

# Functions defined in this module are exported for usage in stylesheets
# (.sass and .scss documents).
#
# Compass Magick exports all available {Compass::Magick::Functions functions}.
module Sass::Script::Functions
  include Compass::Magick::Functions
end
