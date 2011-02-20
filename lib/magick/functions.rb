require 'magick/functions/canvas'
require 'magick/functions/types'
require 'magick/functions/drawing'

module Compass::Magick
  # The Functions module includes all public Compass Magick functions.
  #
  # @see Functions::Canvas
  # @see Functions::Types
  # @see Functions::Drawing
  module Functions
    include Functions::Canvas
    include Functions::Types
    include Functions::Drawing
  end
end

# Functions defined in this module are exported for usage in stylesheets
# (.sass and .scss documents).
#
# Compass Magick exports all available {Compass::Magick::Functions functions}.
module Sass::Script::Functions
  include Compass::Magick::Functions
end
