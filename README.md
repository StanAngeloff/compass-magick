Compass Magick
==============

Dynamic image generation for Compass using ChunkyPNG (no dependency on RMagick).

Example
-------

    body {
      background: transparent magick-canvas(100px, 100px,
        magick-fill(magick-linear-gradient(red, green, blue))
      ) repeat-x;
    }

A CSS3 [Sassy Button](http://jaredhardy.com/sassy-buttons/) recreated in Compass Magick:  
[StanAngeloff.github.com/compass-magick/](http://stanangeloff.github.com/compass-magick/) (showcases all features)

Installation
------------

Installation is simple via RubyGems. [Compass](http://beta.compass-style.org) and [ChunkyPNG](https://github.com/wvanbergen/chunky_png) are required.

    gem install compass-magick

Usage
-----

To start a new Compass project with Magick included:

    compass create -r magick my_project

To use Compass Magick within your existing projects, require the plugin from your Compass configuration:

    require 'magick'

There is a [short tutorial](http://blog.angeloff.name/post/4659977659/compass-magick-tutorial-part-1) available which should guide you through creating a simple themeable button.

APIs
----

[List of all available commands](https://github.com/StanAngeloff/compass-magick/blob/master/APIs.md).

RDoc is also [available for the entire project](http://stanangeloff.github.com/compass-magick/doc/frames.html).

Contribute
----------

Compass Magick is very much a work in progress. Documentation is sparse, speed is a major issue and there are probably a lot of bugs.

You can help by looking at any of the following areas (ordered by priority):

- [Optimizing the code](https://github.com/StanAngeloff/compass-magick/blob/master/lib/magick/canvas.rb#L98) as floating point math may not always be needed and too many object copies sucks
- [Writing tests](https://github.com/StanAngeloff/compass-magick/tree/master/spec) to make sure nothing breaks in new versions
- [Performing code reviews](https://github.com/StanAngeloff/compass-magick/tree/master/lib) since this is my very first Ruby project and I don't have any experience with the language so there are probably many st**OO**pid things in code
- [Improving RDoc](http://stanangeloff.github.com/compass-magick/doc/frames.html) because you can never have too much documentation
- [Adding new plugins](http://stanangeloff.github.com/compass-magick/doc/Compass/Magick/Plugins.html). Compass Magick [looks](https://github.com/StanAngeloff/compass-magick/blob/master/lib/magick.rb#L39) for Ruby files and imports those on startup
- [Submitting more examples](https://github.com/StanAngeloff/compass-magick/tree/gh-pages) to show off what Compass Magick can do
- [Opening issues](https://github.com/StanAngeloff/compass-magick/issues) for features you find missing or broken
- Porting over some of [CamanJS](http://camanjs.com/)' goodness, we all love visual effects

### Credits

- [Willem van Bergen](http://twitter.com/#!/wvanbergen) for his great work on ChunkyPNG which has been a major source of knowledge while working on the project
- [Chris Eppstein](http://twitter.com/#!/chriseppstein) for [Compass](https://github.com/chriseppstein/compass) itself
- The Ruby community for being awesome and welcoming a stranger

### Copyright

Copyright (c) 2011 Stan Angeloff. See [LICENSE.md](https://github.com/StanAngeloff/compass-magick/blob/master/LICENSE.md) for details.
