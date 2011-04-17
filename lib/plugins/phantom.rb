module Compass::Magick
  module Configuration
    # Registers a new property in config.rb `phantom_executable` which allows
    # Users to configure the location of the PhantomJS binary.
    #
    # You would usually have `phantomjs` on $PATH, but in cases where you have
    # installed it to another directory, you can specify the full path using
    # this property.
    add_property :phantom_executable

    # Registers a new property in config.rb `phantom_script` which allows
    # Users to configure the location of the PhantomJS rendering script.
    #
    # This is very useful on Cygwin installations where Cygwin paths don't
    # mix well with a Windows build of PhantomJS.
    add_property :phantom_script

    # Emits the comment for the `phantom_executable` property into the
    # configuration file when serialized -- makes it easier to understand for
    # new Users.
    #
    # @return [String] The comment for the `phantom_executable` property.
    def comment_for_phantom_executable
      "# Path to the PhantomJS binary\n"
    end

    # Emits the comment for the `phantom_script` property into the
    # configuration file when serialized -- makes it easier to understand for
    # new Users.
    #
    # @return [String] The comment for the `phantom_script` property.
    def comment_for_phantom_script
      "# Path to magick.js used to render a web page (using PhantomJS, a headless WebKit)\n"
    end

    # Provides the default value for `phantom_executable` when one isn't
    # specified in the configuration file.
    #
    # @return [String] The default path to the PhantomJS binary.
    def default_phantom_executable
      ENV['PHANTOM_PATH'] || 'phantomjs'
    end

    # Provides the default value for `phantom_script` when one isn't
    # specified in the configuration file.
    #
    # @return [String] The default path to the magick.js script used to
    #   render a web page.
    def default_phantom_script
      cygwin_path(ENV['PHANTOM_SCRIPT'] || File.join(EXTRAS_PATH, 'magick.js'))
    end
  end

  module Plugins
    # Creates a new {Canvas} with the given width and height and renders all
    # styles using the PhantomJS headless Webkit. The resulting image is
    # cropped by removing all transparent pixels.
    #
    # The PhantomJS viewport will be set to `width` / `height` with
    # padding: max(`width`, `height`). If you apply drop shadows or outlines,
    # the returned image will be larger than the specified size to accommodate
    # the overflowing content.
    #
    # @see {Compass::Magick::Configuration}
    # @overload magick_phantom(width, height, styles)
    #   @param [Sass::Script::Number] width The (desired) width of the canvas.
    #   @param [Sass::Script::Number] height The (desired) height of the
    #     canvas.
    #   @param [{String => Sass::Script::String}] styles The CSS styles to
    #     render in PhantomJS where the hash key is the CSS property name and
    #     the hash value is the CSS property value.
    # @overload magick_phantom(width, height, *styles)
    #   @param [Sass::Script::Number] width The (desired) width of the canvas.
    #   @param [Sass::Script::Number] height The (desired) height of the
    #     canvas.
    #   @param [[String]] styles A list of CSS styles to render in PhantomJS.
    # @return {Canvas} A new Canvas instance cropped of all transparent
    #   pixels.
    def magick_phantom(width, height, *args)
      Compass::Magick::Utils.assert_type 'width',  width,  Sass::Script::Number
      Compass::Magick::Utils.assert_type 'height', height, Sass::Script::Number
      elements = []
      args.each do |styles|
        Compass::Magick::Utils.assert_one_of 'magick-phantom(..)', styles, Sass::Script::String, Hash
        instructions = []
        if styles.kind_of?(Sass::Script::String)
          instructions.push(styles.value)
        else
          styles.each do |key, value|
            instructions.push("#{key.gsub('_', '-')}: #{value.kind_of?(Sass::Script::String) ? value.value : value.to_s}")
          end
        end
        elements.push(instructions.join('; '))
      end
      basename = "~magick-phantom-#{ rand(36**8).to_s(36) }.png"
      filename = File.join(Compass.configuration.images_path, basename)
      command  = [Compass.configuration.phantom_executable, Compass.configuration.phantom_script]
      command  = command.concat([width.to_s, height.to_s])
      command  = command.concat(elements)
      command  = command.concat([Compass::Magick::Configuration.cygwin_path(filename)])
      begin
        system(command.shelljoin)
        canvas = Canvas.new(Sass::Script::String.new(basename))
        min_top    = canvas.height - 1
        max_right  = 0
        max_bottom = 0
        min_left   = canvas.width - 1
        for y in 0...canvas.height
          for x in 0...canvas.width
            if ! ChunkyPNG::Color.fully_transparent?(canvas.get_pixel(x, y))
              min_top    = y if y < min_top
              max_right  = x if x > max_right
              max_bottom = y if y > max_bottom
              min_left   = x if x < min_left
            end
          end
        end
        if min_left < max_right && min_top < max_bottom
          canvas.crop(min_left, min_top, max_right - min_left + 1, max_bottom - min_top + 1)
        else
          puts '(Compass:Magick) Phantom image rendering failed. Please make sure you have at least one drawing instruction in your styles:'
          puts "$ #{command.shelljoin}"
          canvas
        end
      ensure
        File.unlink(filename) if File.exists?(filename)
      end
    end

    Sass::Script::Functions.declare :magick_phantom, [:width, :height], :var_args => true, :var_kwargs => true
  end
end
