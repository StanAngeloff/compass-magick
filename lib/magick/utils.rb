module Compass::Magick
  # Utilities methods used throughout Compass Magick.
  module Utils
    extend self

    # Checks if <tt>arg</tt> is of the expected <tt>type</tt> or raises a
    # {TypeMismatch} exception otherwise.
    #
    # @param [String] name The argument name used in the exception message.
    # @param [Object] arg The argument to validate.
    # @param [Object] type The expected <tt>arg</tt> type.
    def assert_type(name, arg, type)
      raise TypeMismatch.new "(#{self.class}) Type mismatch for argument '#{name}', #{arg.inspect}" unless arg.kind_of? type
    end
  end
end
