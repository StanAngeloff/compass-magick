module Compass::Magick::Util
  def number_value(number, length, default = nil)
    return default if number.nil? || number.is_a?(Sass::Script::Bool)
    return length * (number.value.to_f / 100) if number.unit_str === '%'
    return length + number.value if number.value < 0
    number.value
  end
end
