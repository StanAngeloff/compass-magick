Compass Magick
==============

a RMagick utility for Sass.

The aim of this project is to allow designers to generate images on-the-fly
why authoring their stylesheets:

    background: transparent magick-image('nav.png', 940px, 50px,
      magick-erase(#4fb1e2),
      magick-linear-gradient(rgba(255, 255, 255, 0.5), rgba(255, 255, 255, 0), false),
      magick-top-left-corner(10px),
      magick-top-right-corner(10px)
    );

**THIS IS VERY MUCH A WORK IN PROGRESS.  
  MORE DOCUMENTATION WILL BE ADDED SOON**
