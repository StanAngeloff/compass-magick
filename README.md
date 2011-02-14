Compass Magick
==============

a RMagick utility for Sass.

The aim of this project is to allow designers to generate images on-the-fly
while authoring their stylesheets. Compass Magick currently supports:

* Semi-transparent backgrounds
* 2-point linear gradients incl. support for rgba(..)
* Rounded corners
* Borders incl. rounded borders
* Image composing, i.e., drawing images on top of the canvas

A sample command looks like this:

    background: transparent magick-image('nav.png', 940px, 50px,
      magick-erase(blue),
      magick-linear-gradient(rgba(255, 255, 255, 0.5), rgba(255, 255, 255, 0)),
      magick-top-left-corner(10px),
      magick-top-right-corner(10px)
    );

**THIS IS VERY MUCH A WORK IN PROGRESS.  
  MORE DOCUMENTATION WILL BE ADDED SOON.**

Installation
------------

The are no official releases or Gems available yet. You can grab the code
from Github and copy it in `extensions/compass-magick` under your Compass
project.

Read more about [Installing Ad-hoc Extensions](http://compass-style.org/docs/tutorials/extensions/).

Usage
-----

* **magick-image**([filename, ]width, height[, format], *commands)  
  Create a new image with the given `width` and `height`. If `filename` is
  set, save the image on disk and return the path to it. If `filename` is
  missing, return a Base64 encoded image in `format`, or assume 'PNG' if not
  specified.

* **magick-erase**(color[, x1, y1, x2, y2])  
  Erase the given region, or the entire image, with `color`. RGBA values are
  supported.

* **magick-linear-gradient**(*stops[, angle[, x1, x2, y1, y2]])  
  Generate a linear gradient in the given region, or the entire image, with
  at least one color stop at the specified angle. RGBA values are supported. 
  You can either specify color values:

        magick-linear-gradient(orange, blue, yellow)

  which will generate color stops at 0%, 50% and 100% or you can set the stops
  yourself:

        magick-linear-gradient(
          magick-color-stop(0%,  orange),
          magick-color-stop(25%, blue),
          magick-color-stop(35%, yellow)
        )

  Gradients work best with two color stops.

* **magick-top-left-corner**(radius)  
  **magick-top-right-corner**(radius)  
  **magick-bottom-right-corner**(radius)  
  **magick-bottom-left-corner**(radius)  
  **magick-corner**(radius)  
  Generate a rounded corner in the given edge, or all, at the specified
  `radius`.

* **magick-border**(color[, width[, radius[, x1, y1, x2, y2]]])  
  Draw a (rounded) border around the given region, or the entire image, with
  the specified `width`. If you want rounded corners and a border on your
  image, you should use this command after `magick-corner`.

* **magick-composite**(source[, x, y][, invert][, mode])  
  Load external image from `source` and put it on top of the canvas at the
  specified position, or the top-left corner. The image is blended using
  `mode` which defaults to 'SrcOver'. See [RMagick's documentation](http://studio.imagemagick.org/RMagick/doc/constants.html#CompositeOperator)
  for more options.  
  If `invert` is `true`, `source` is used as the destination.

License
-------

> The MIT License
> 
> Copyright (c) 2011 Stan Angeloff
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
