Compass Magick APIs
===================

- `magick-canvas(       canvas, [command[, command[, …]]])`  
  `magick-canvas(         data, [command[, command[, …]]])`  
  `magick-canvas(          url, [command[, command[, …]]])`  
  `magick-canvas(         path, [command[, command[, …]]])`  
  `magick-canvas(width, height, [command[, command[, …]]])`

  This is probably the most important function. It creates a new canvas and execute commands on it. The resulting image is returned as a Base64 encoded Data URL.

  **Example:**

      // Creates a canvas from file
      magick-canvas('input.png')

      // Creates a transparent canvas 320px wide and 200px tall
      magick-canvas(320px, 200px)

  You can use the output of the function to embed your images directly in the stylesheet, however not all browsers and versions support Data URLs.

- `magick-sprite(basename, canvas)`

  Writes the generated canvas to a file encoded as a PNG image. The output is optimized for best compression.  
  The generated file is saved in the configured images directory with a `.png` extension. Directory names are allowed and can be used to group a set of objects together.
  (Depending on your configuration) The returned path is relative and has the cache buster appended after the file extension.

  **Example:**

      // config.rb should have this line:
      // images_dir = 'images'

      // Writes a transparent 10x10 canvas to images/blank.png
      magick-sprite('blank', magick-canvas(10px, 10px))

      // This canvas is part of a group of images, save it in its own directory
      magick-sprite('buttons/glossy/pressed', magick-canvas(/* … */))

- `magick-fill(type, [x1[, y1[, x2[, y2]]]])`

  Fills the canvas region. Supported types are:

    * Color
    * Linear Gradient
    * Canvas
    * Pattern

  You can pass negative values to `x2` and `y2` to offset them from the canvas width and height accordingly.

  **Example:**

      // Fills the entire canvas using a color
      magick-fill(red)

      // Fills the entire canvas using a semi-transparent color
      magick-fill(rgba(255, 255, 255, 0.5))

      // Fills the entire canvas using a linear gradient
      magick-fill(magick-linear-gradient(red, green, blue))

      // Fills the canvas leaving a 10px edge on all sides
      magick-fill(blue, 10px, 10px, -10px, -10px)

      // Fills using another canvas as the texture
      magick-fill(magick-canvas('bricks.png'))

  If `type` is a Sass list, the first item is used to generate the fill and every other item is applied as a mask:

      // Fills the entire canvas with an image slowly fading it away towards the bottom:
      magick-fill(
        magick-canvas('bricks.png')  // No trailing comma for a Sass list
        magick-linear-gradient(white, black)
      )

- `magick-border(type[, radius[, width[, top_left[, top_right[, bottom_right[, bottom_left]]]]]])`

  Draws a border around the canvas with the given width and fill. See `magick-fill` for supported types.  
  When `width` is not given, the border fills the entire image.

  **Example:**

      // Draws a 1px black border, no rounding around the corners
      magick-border(black, 0, 1px)

      // Fills the entire canvas with black and adds a 10px rounded corners
      magick-border(black, 10px)

      // Draws a 10px black border with 5px rounding around the corners
      magick-border(black, 5px, 10px)

  The last four optional arguments to the function control rounding at every corner:

      // Draws a 1px rainbow border with 10px rounded top corners
      magick-border(magick-linear-gradient(red, green, blue), 10px, 1px, true, true, false, false)

- `magick-corners(radius[, top_left[, top_right[, bottom_right[, bottom_left]]]])`

  Applies rounded corners around the canvas. This is a essentially `magick-border(white, radius)` applied as a mask (see below for `magick-mask`).

  **Example:**

      // Applies 10px rounding around the corners
      magick-corners(10px)

- `magick-compose(overlay[, x[, y]])`

  Composes one canvas on top of another.

  **Example:**

      // Draws icon.png in the top-left corner
      magick-compose(magick-canvas('icon.png'))

      // Draws arrow.png at 10px horizontally and vertically centered
      magick-compose(magick-canvas('arrow.png'), 10px, 50%)

- `magick-linear-gradient(       stops)`  
  `magick-linear-gradient(angle, stops)`

  Creates a new linear gradient. Compass Magick supports gradients everywhere colors are accepted (e.g., borders). By default the angle of the gradient is 90deg. You can override this by specifying a number as the first argument to the function:

      magick-linear-gradient(45deg, red, green, blue)

  If you specify only color names, they will be positioned such as they are equally apart. You can override this behaviour by using color stops:

      magick-linear-gradient(
        magick-color-stop(50%, red),
        magick-color-stop(65%, blue)
      )

  A shorter (implicit) version for color stops is also provided, following the CSS3 syntax:

      magick-linear-gradient(
         red 50%,
        blue 65%
      )

  Gradients are not drawing functions and cannot be used directly on the canvas. You apply them as part of another function call, e.g., `magick-fill`:

      magick-fill(magick-linear-gradient(red, green, blue))

  **Example:**

      magick-canvas(320px, 200px,
        magick-fill(
          magick-linear-gradient(
            yellow 25%,
               red 50%
          )
        )
      )

- `magick-drop-shadow([angle[, distance[, size[, color]]]])`

  Apply a drop shadow effect on the canvas.

  The alpha channel is used to construct a mask of the original image which is then used as a base for the horizontal/vertical shadow pass.  
  This is essentially a B/W copy of your canvas with blur applied composed below the original canvas.

  **Example:**

      magick-drop-shadow(90deg, 5px, 5px, black)

  If you have filled the entire canvas with a color/gradient, you are likely not going to find this function very helpful. The following will generate a button, but the shadow will **not** be visible:

      magick-canvas(320px, 24px,
        magick-fill(magick-linear-gradient(red, maroon))
        magick-corners(10px)
        magick-border(maroon, 10px, 1px)
        magick-drop-shadow(270deg)
      )

  You can compose your main canvas on top of another one which has padding applied so the drop shadow effect would be visible:

      magick-canvas(340px, 44px,  // This is the larger canvas. 10px padding on all sides
        magick-compose(magick-canvas(320px, 24px,  // The main canvas
          magick-fill(magick-linear-gradient(red, maroon))
          magick-corners(10px)
          magick-border(maroon, 10px, 1px)
        ), 50%, 50%)  // The main canvas is centered within the larger one
        magick-drop-shadow(270deg)  // Drop shadow is applied on the larger canvas
      )

- `magick-effect(name[, adjust])`

  Apply a per-pixel effect on canvas.

    * `fade`              lowers the alpha channel by `adjust` (0%—100% or 0—1.0)
    * `brightness` modifies the [R, G, B] channels by `adjust` (-100%—100% or -255—255)
    * `contrast`   modifies the [R, G, B] channels by `adjust` (at least 0%, can be above 100% to achieve over-exposure)
    * `saturation` modifies the [R, G, B] channels by `adjust` matching the highest intensity (-100%—100% or -1.0—1.0, values outside this range to achieve over-exposure)
    * `vibrance`   modifies the [R, G, B] channels by `adjust` matching the average intensity (-100%—100% or -1.0—1.0, values outside this range to achieve over-exposure)
    * `grayscale`  modifies the [R, G, B] channels intensity by `adjust` according to BT709 luminosity factors (0%—100% or 0—1.0)

  **Example:**

      # Increases the contract by 50%
      magick-effect(contrast, 50%)

      # Makes the canvas semi-transparent
      magick-effect(fade, 50%)

- `magick-crop([x1[, y1[, x2[, y2]]]])`

  Crops the canvas to the given region.

  **Example:**

      # Crops 10px on each side
      magick-crop(10px, 10px, -10px, -10px)

- `magick-mask(mask[, x[, y]])`

  Applies a mask on the canvas.

  Composes the alpha channel from `mask` with the one from the canvas and return the original canvas with the alpha-channel modified. Any opaque pixels from the `mask` are converted to grayscale using BT709 luminosity factors, i.e. black is fully transparent and white is fully opaque.

  **Example:**

      magick-mask('mask.png')

  Masks are extremely useful when you have custom shapes, e.g., an iPhone-styled back button. You can use Photoshop (or your software of choice) to produce the mask and let Compass Magick generate the gradient for your theme.

- `magick-pattern(width, height, values)`

  Generates a pattern and returns a B/W Canvas ready for masking.

  The pattern is defined as a list of values (or a multi-line string) where `1`, `true`, `yes`, `X`, `*` and `+` mark where an opaque white pixel should be placed. Any other value is ignored and is transparent in the output. The size of the list must match the `width`/`height` given.

  **Example:**

      // Diagonal stripes, 'x' marks the spot
      magick-pattern(3, 3,
        x _ _
        _ x _
        _ _ x
      );

      // Red diagonal stripes
      magick-canvas(3, 3,
        magick-fill(red),
        magick-mask(
          magick-pattern(3, 3,
            o o X  // Using 'o' for transparent pixels
            o X o
            X o o
          )
        )
      );

  Since `magick-fill` treats every argument after the first one as a mask, the last example can be re-written as:

      magick-fill(
        red  // No trailing comma for a Sass list
        magick-pattern(3, 3,
          o o X
          o X o
          X o o
        )
      )
