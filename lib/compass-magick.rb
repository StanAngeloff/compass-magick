module Compass::Magick; end

begin
  # Gem install
  require 'rubygems'
  require 'RMagick'
  require 'compass-magick/command'
  require 'compass-magick/functions'
rescue LoadError
  # Local install
  $LOAD_PATH.unshift File.dirname(__FILE__)
  require 'RMagick'
  require 'compass-magick/command'
  require 'compass-magick/functions'
end

Compass::Frameworks.register('compass-magick',
  :stylesheets_directory => File.join(File.dirname(__FILE__), 'stylesheets'),
  :templates_directory   => File.join(File.dirname(__FILE__), 'templates')
)
