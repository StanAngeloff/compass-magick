# Local development requires we have the current directory on $LOAD_PATH.
$: << File.dirname(__FILE__)

require 'chunky_png'

require 'magick/utils'
require 'magick/scriptable'
require 'magick/command'
require 'magick/canvas'
require 'magick/types'
require 'magick/functions'

# Compass Magick, a library for dynamic image generation.
#
# The Compass::Magick module defines constants and exception used throughout
# the project.
#
# @author Stan Angeloff
module Compass::Magick
  # The current version of Compass Magick. This value is updated manually on
  # release. If you are using a Git clone, the version will always end with
  # '.git'.
  VERSION = '0.1.0.git'

  # Default exception class for Compass Magick
  class Exception < ::StandardError; end

  # Exception that is raised when an argument's type does not match the
  # expected.
  class TypeMismatch < Exception; end

  # Exception that is raised when an abstract method is called.
  class AbstractMethod < Exception; end

  # Exception that is raised when a method is called with arguments it does
  # not support.
  class NotSupported < Exception; end

  # Exception that is raised when a method is called in a context it does not
  # support.
  class NotAllowed < Exception; end
end

# Register Compass Magick as a Compass framework.
#
# @see http://compass-style.org/docs/tutorials/extensions/
Compass::Frameworks.register('magick',
  :stylesheets_directory => File.join(File.dirname(__FILE__), 'stylesheets'),
  :templates_directory   => File.join(File.dirname(__FILE__), 'templates')
)
