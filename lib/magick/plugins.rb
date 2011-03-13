module Compass::Magick
  # The Plugins module includes all external Compass Magick functions.
  #
  # @see Compass::Magick::PLUGINS_PATH
  module Plugins; end

  PLUGINS_PATH.each do |path|
    if File.exists?(path)
      Dir.glob(File.join(path, '**', '*.rb')).each do |plugin|
        require plugin
      end
    end
  end
end
