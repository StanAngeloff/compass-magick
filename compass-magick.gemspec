Gem::Specification.new do |s|
  s.name        = 'compass-magick'
  s.version     = '0.0.1'
  s.date        = '2011-02-14'
  s.summary     = %q{A RMagick utility for Compass. Create dynamic images on-the-fly, incl. support for gradients, filters, cropping, etc.}
  s.description = %q{A RMagick utility for Compass. Create dynamic images on-the-fly, incl. support for gradients, filters, cropping, etc. Uses RMagick 2.}
  s.authors     = ['Stan Angeloff']
  s.email       = 'stanimir@angeloff.name'
  s.homepage    = 'https://github.com/StanAngeloff/compass-magick'

  s.files  = %w(LICENSE README.md)
  s.files += Dir.glob('lib/**/*.*')
  s.files += Dir.glob('stylesheets/**/*.*')

  s.has_rdoc         = false
  s.require_paths    = ['lib']
  s.rubygems_version = %q{1.3.6}

  s.add_dependency 'rmagick', '>= 2.0.0'
end
