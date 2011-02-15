require 'RMagick'

module Compass::Magick;
  $LOAD_PATH.unshift File.dirname(__FILE__)
end

require 'compass-magick/util'
require 'compass-magick/types'
require 'compass-magick/commands'
require 'compass-magick/functions'

Compass::Frameworks.register('compass-magick',
  :stylesheets_directory => File.join(File.dirname(__FILE__), 'stylesheets'),
  :templates_directory   => File.join(File.dirname(__FILE__), 'templates')
)
