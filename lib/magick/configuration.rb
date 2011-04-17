module Compass::Magick
  # Configuration methods to allow plugins to register new configurable
  # properties.
  module Configuration
    extend Compass::Configuration::Inheritance::ClassMethods

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
    def self.add_property(name)
      Compass::Configuration::ATTRIBUTES.push(name)
      inherited_accessor(name)
    end
  end
end
