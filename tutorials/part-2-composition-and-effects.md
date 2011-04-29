Compass Magick Tutorial - Part 2
================================

There is more to Compass Magick than gradients and borders. In the second part of the tutorial series, we will go through the steps to create a simple 3-state button with an icon.

Recap of [Part 1](http://blog.angeloff.name/post/4659977659/compass-magick-tutorial-part-1)
-------------------------------------------------------------------------------------------

In Part 1 we completed the tutorial with a simple button-like shape:

![Example 4](http://i.imgur.com/hBLg0.png)

We generated the shape using linear gradients, corners and borders from Magick:

    // intro.scss
    $theme1: red;
    $theme2: maroon;

    $button_width:  320px;
    $button_height: 24px;

    body {
      background: transparent magick-canvas($button_width, $button_height,
        magick-fill(
          magick-linear-gradient(
            $theme1,
            $theme2
          )
        )
        magick-corners(10px)
        magick-border($theme2, 10px, 1px)
      );
    }

To ensure we can easily change the theme colours, we introduced two `$theme` variables at the top of the file.

Adding an Icon to the Button
----------------------------

Pick an [image](http://www.iconfinder.com/icondetails/27854/24/about_information_icon) and save it in your `images_dir` as `icon.png`. If you skipped Part 1 of this tutorial, make sure you have a directory named `images` in your project's root and add the following line to your Compass configuration:

    # Add to config.rb
    images_dir = 'images'

Magick comes with a very handy `magick-compose` function which allows us to put one canvas on top of another. We cannot pass the image file directly to `magick-compose` as it will refuse anything other than a canvas object:

    // This will NOT work
    magick-compose('icon.png')

You've seen how to create a blank canvas using the `magick-canvas` function. We can also initialise a canvas object in several other ways, one of which includes the option to load a file from disk:

    // Loads icon.png and returns a Base64 encoded Data URL
    magick-canvas('icon.png')

Let's put the two together for a working solution:

    // Loads icon.png and uses it as an overlay
    magick-compose(magick-canvas('icon.png'))

Adding the above line to our button code:

    // {intro => button}.scss
    /* …snip… */

    body {
      background: transparent magick-sprite('button', magick-canvas($button_width, $button_height,
        /* …snip… */
        magick-compose(magick-canvas('icon.png'))
      ));
    }

Yields the following result:

![Example 5](http://i.imgur.com/LxR7H.png)

It's not exactly what I would call pretty so let's make some changes to the dimensions and colours of the button:

    // button.scss
    $theme1: #3060bf;
    $theme2: #5ca1e5;

    $button_width:  280px;
    $button_height: 32px;

    /* …snip… */

![Example 6](http://i.imgur.com/QrO1E.png)

The CSS `background-position` property allows control over where a background image appears inside its container. `magick-compose` gives us similar control. To offset the icon 5px horizontally and center it vertically, we pass `5px, 50%` after the canvas object (note arguments are comma-separated):

    // button.scss
    /* …snip… */

    body {
      background: transparent magick-sprite('button', magick-canvas($button_width, $button_height,
        /* …snip… */
        magick-compose(magick-canvas('icon.png'), 5px, 50%)
      ));
    }

![Example 7](http://i.imgur.com/1dGXv.png)

Applying Effects
----------------

Magick packs several pixel-based effects - fade, brightness, contrast, saturation, vibrance and greyscale. We apply them to a canvas object just like we would apply borders or corners:

    magick-effect(fade, 50%)

The first argument selects the desired effect and the second one adjusts its strength.

For this tutorial, let's tune down the icon by making it semi-transparent and reducing the colour intensity:

    /* …snip… */
    magick-compose(
      magick-canvas('icon.png',
        magick-effect(fade,      50%)
        magick-effect(greyscale, 50%)
      ),
      5px, 50%
    )
    /* …snip… */

![Example 8](http://i.imgur.com/yvRaX.png)

The effects are applied to the canvas we are composing on top of the button shape. If we move `magick-effect` to the top-level canvas (where borders and corners are applied) then the entire button will be semi-transparent - not what we are after.

Sprites, the Compass Way
------------------------

We are building a 3-state button. So far we have only constructed the code for our normal state. For the hover state, we simply remove the effects applied on the icon earlier. For the active state, we invert the gradient so the button appears pressed.

We could save the three states as three different images, but this is not good practise and it will result in three requests to the server.  
The latest release of Compass offers an easy-to-use [spriting support](http://compass-style.org/help/tutorials/spriting/). You import the different button states and Compass takes care of the rest.

Let's start by moving our button code from the `body` CSS selector to a `$button_sprites` Sass variable.

    // button.scss
    $theme1: #5ca1e5;
    $theme2: #3060bf;

    $button_width:  280px;
    $button_height: 32px;

    $button_sprites: magick-sprite('button', magick-canvas($button_width, $button_height,
      magick-fill(
        magick-linear-gradient(
          $theme1,
          $theme2
        )
      )
      magick-corners(10px)
      magick-border($theme2, 10px, 1px)
      magick-compose(
        magick-canvas('icon.png',
          magick-effect(fade,      50%)
          magick-effect(greyscale, 50%)
        ),
        5px, 50%
      )
    ));

    body { }

If we look at the generated CSS, it should be an empty file since there isn't any code in the `body`. However, `button.png` is still generated in `images_dir` which is what we are after.

Before we proceed to out hover state, let's rename the generated sprite from `'button'` to `'button/normal'` which will generate a file `button/normal.png`. This naming convention is compatible with Compass spriting.

For our hover state, we copy the code for the normal state and remove the effects on the button icon. Append the code to `$button_sprites`:

    // button.scss
    /* …snip… */

    $button_sprites: magick-sprite('button/normal', magick-canvas($button_width, $button_height,
      /* …snip… */
    )) magick-sprite('button/hover', magick-canvas($button_width, $button_height,
      magick-fill(
        magick-linear-gradient(
          $theme1,
          $theme2
        )
      )
      magick-corners(10px)
      magick-border($theme2, 10px, 1px)
      magick-compose(magick-canvas('icon.png'), 5px, 50%)
    ));

    body { }

We end up with two files: `button/normal.png` and `button/hover.png`.

Finally, copy the code for the hover state and play with the gradient stops to achieve a pressed button look. Append the code to `$button_sprites` again:

    // button.scss
    /* …snip… */

    $button_sprites: magick-sprite('button/normal', magick-canvas($button_width, $button_height,
      /* …snip… */
    )) magick-sprite('button/hover', magick-canvas($button_width, $button_height,
      /* …snip… */
    )) magick-sprite('button/active', magick-canvas($button_width, $button_height,
      magick-fill(
        magick-linear-gradient(
          darken($theme2, 10%),
          mix($theme1, $theme2)
        )
      )
      magick-corners(10px)
      magick-border($theme2, 10px, 1px)
      magick-compose(magick-canvas('icon.png'), 5px, 50%)
    ));

    body { }

We are now ready to create a single image for our 3-state button. It is as easy as adding an `import` line above the `body`:

    // button.scss
    /* …snip… */

    @import 'button/*.png';

    body { }

![Example 9](http://i.imgur.com/jg8Ao.png)

Using the Button Sprite
-----------------------

The final step is to turn an `<a>` element into a button:

    a {
      display: block;
      width: $button_width;
      height: $button_height;
      line-height: $button_height;
      text-align: center;
      text-decoration: none;
      color: #fff;

      @include button-sprite(normal);

      &:hover  { @include button-sprite(hover); }
      &:active { @include button-sprite(active); }
    }

The `button-sprite` mixins are generated by Compass and allow us to easily switch the `background-position` property to select the desired button state. The result is:

<iframe style="width: 100%; height: 200px" src="http://jsfiddle.net/aFNFu/embedded/result/"></iframe>

Conclusion
----------

There are many more features available in Magick. Check out the [list of all available commands](https://github.com/StanAngeloff/compass-magick/blob/master/APIs.md) for a comprehensive reference.

Leave a comment if you have any questions or suggestions and visit the [official Github](https://github.com/StanAngeloff/compass-magick) page of the project for up-to-date information and links to other resources.
