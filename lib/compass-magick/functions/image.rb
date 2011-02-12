require File.join(Compass.lib_directory, 'compass', 'sass_extensions', 'functions', 'urls')

module Compass::Magick::Functions::Image
  include Compass::SassExtensions::Functions::Urls

  def magick_image(filename, width, height, *commands)
    image = Magick::Image.new(width.value, height.value) do
      self.background_color = 'none'
    end
    commands.each do |command|
      result = command.invoke(image)
      image  = result if result.is_a?(Magick::Image)
    end
    path = File.join(Compass.configuration.images_path, filename.value);
    FileUtils.mkpath File.dirname(path)
    image.write(path)
    image_url(filename)
  end
end
