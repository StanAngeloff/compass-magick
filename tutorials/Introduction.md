Compass Magick Tutorial - Part 1
================================

Introduction
------------

We have all been there - you release a cool new website with all the goodies of CSS3 just to find several weeks later your Customer wants you to support Internet Explorer as well. It seems solid backgrounds don't cut it.

There are also cases where CSS3 isn't the right solution, whether you have custom shapes or other elements of your design you end up creating images for (SVG is a good solution for these cases, but there's that big 10-year old elephant sitting in the middle of the room again).

Compass Magick tries to solve these issues by allowing you to dynamically generate images from your Compass projects taking full advantage of variables, mixins, etc.

History
-------

The initial version of the project relied on RMagick for all image manipulation. There were many quirks: gradients were not working properly, per-pixel manipulation was difficult and much more.
While I haven't worked with Ruby myself before, it also became apparent after some time RMagick was a big no-no in Ruby's land. The project is not actively maintained (last commit at the time of writing this post was on October 25, 2010) and compiling it is a big pain (especially on Windows/Cygwin).

Searching for an alternative solution, I stumbled upon [compass-rgba](http://www.aaronrussell.co.uk/blog/cross-browser-rgba-support/), a simple plugin for generating 1x1 images and saving them as PNG files, the goal being to support IE7 with its missing implementation for `rgba`.
The plugin is using [ChunkyPNG](https://github.com/wvanbergen/chunky_png), a pure Ruby library for reading and writing PNG images. Upon further investigation, I found it has very good support for per-pixel access and was a breeze to install. The author, Willem van Bergen, is also actively maintaining it, constantly adding new features and releasing new versions.

Installation
------------

Moving away from the brief history lesson, installing Compass Magick is simple via RubyGems. [Compass](http://beta.compass-style.org) ~> 0.11.beta.5 and [ChunkyPNG](https://github.com/wvanbergen/chunky_png) ~> 1.1.0 are required.

    gem install compass-magick

You can optionally install OilyPNG ~> 1.0.0 to speed up ChunkyPNG. Oily is a native mixin:

    gem install oily_png

If you have an existing project, you can start using Compass Magick by requiring the plugin from your Compass configuration:

    # Add as the the first line in your config.rb
    require 'magick'

If you are starting a new Compass project, to include Magick add `-r magick` to the command line:

    compass create -r magick my_project

A Surface
---------

Everything starts with a canvas:

    magick-canvas(320px, 200px)

The code above creates a new Magick canvas and initialises its width and height. The canvas is fully transparent. This line by itself doesn't do much, so let's add it as a page background:

    // intro.scss
    body {
      background: transparent magick-canvas(320px, 200px);
    }

Once you compile the source `intro.scss`, have a look at the produced `.css` - you should see a Base64 encoded Data URL of what is essentially a 320x200 transparent PNG serialised:

    body {
      background: transparent url('data:image/png;base64,…');
    }

Commands
--------

You can perform drawing operations on a Magick canvas just like any other canvas. Commands are executed in the order they are specified in the source file. There are commands for drawing borders, generating gradients and much more. To keep things simple, let's turn our transparent canvas yellow:

    // intro.scss
    body {
      background: transparent magick-canvas(320px, 200px,
        magick-fill(yellow)
      );
    }

![Example 1](http://i.imgur.com/j1KUk.png)

…and just like that we turned our canvas yellow. `magick-fill` accepts semi-transparent colors and most importantly of all, variables:

    // intro.scss
    $theme1: yellow;
    $theme2: blue;

    body {
      background: transparent magick-canvas(320px, 200px,
        magick-fill($theme1)
        magick-fill(rgba($theme2, 0.5))
      );
    }

![Example 2](http://i.imgur.com/3o3yy.png)

What happened there? We created a 320x200 canvas and executed two commands on it:

1. Fill the entire canvas with `$theme1` (yellow)
2. Fill the entire canvas again with `$theme2` (blue), but at 50% opacity

Types
-----

Compass Magick has support for linear gradients. Gradients are not drawing functions, but fill types. You don't apply a gradient directly on the canvas, rather you use it as an argument to a drawing function, one like `magick-fill` for example. Let's create a very simple top-to-bottom gradient and apply it on our canvas from the previous examples:

    // intro.scss
    $theme1: red;
    $theme2: maroon;

    body {
      background: transparent magick-canvas(320px, 200px,
        magick-fill(
          magick-linear-gradient(
            $theme1,
            $theme2
          )
        )
      );
    }

![Example 3](http://i.imgur.com/V9pb3.png)

Going Further
-------------

Compass Magick has a very powerful [set of functions](https://github.com/StanAngeloff/compass-magick/blob/master/APIs.md). Adding corners and a border is trivial and we can quickly turn our canvas into a button:

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

![Example 4](http://i.imgur.com/hBLg0.png)

Saving the Canvas
-----------------

Unfortunately Base64 encoded Data URLs are not supported by all browsers and versions. To save the button we generated on disk, we first need to alter our Compass configuration:

    # Add to config.rb
    images_dir = 'images'

We can now wrap everything in `magick-sprite` to write the output on disk:

    // intro.scss
    /* …snip… */

    body {
      background: transparent magick-sprite('button', magick-canvas($button_width, $button_height,
        /* …snip… */
      ));
    }

The result will be `button.png` in the configured `images_dir`. The file is optimised for best compression, but you could further post-process it with tools like [OptiPNG](http://optipng.sourceforge.net/).

Conclusion
----------

This post is just an introduction to Compass Magick. There are many more features available, some of which include image composing, cropping, masking, drop shadows and pattern generation.
Check out the [list of all available commands](https://github.com/StanAngeloff/compass-magick/blob/master/APIs.md) for a comprehensive reference.

I hope you found this short walk-through useful.
Leave a comment if you have any questions or suggestions and visit the [official Github](https://github.com/StanAngeloff/compass-magick) page of the project for up-to-date information and links to other resources.
