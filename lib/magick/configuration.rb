require 'shellwords'

module Compass::Magick
  # Configuration methods to allow plugins to register new configurable
  # properties.
  module Configuration
    extend Compass::Configuration::Inheritance::ClassMethods
    extend self

    # Registers a new property in `config.rb`.
    #
    # If you use this method, you should also define two additional methods:
    #
    # - comment_for_#{name} - emits a comment against the properly into the
    #   configuration file when serialized
    # - default_{#name} - provides a default value for the property when one
    #   isn't specified in the configuration file
    #
    # @param [Symbol] name The name of the property.
    def add_property(name)
      Compass::Configuration::ATTRIBUTES.push(name)
      inherited_accessor(name)
    end

    # Converts a Cygwin Unix path to a Windows path, e.g.:
    #
    #     /cygdrive/d/path/to/file
    #       ==>
    #     D:/path/to/file
    #
    # @param [String] path The Unix path to convert.
    # @return [String] The Windows path.
    def cygwin_path(path)
      if RUBY_PLATFORM.include?('cygwin') && path.index('/') == 0
        IO.popen("cygpath -m #{path.include?(':') ? '-p' : ''} #{path.shellescape}").readline.chomp.gsub(/;/, '\\;')
      else
        path
      end
    end
  end
end
