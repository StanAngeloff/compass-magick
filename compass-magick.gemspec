Gem::Specification.new do |s|
  s.name     = 'compass-magick'
  s.summary  = 'Dynamic image generation for Compass using ChunkyPNG/PhantomJS.'

  s.version  = IO.read(File.join(File.dirname(__FILE__), 'lib/magick.rb')).scan(/VERSION\s*=\s*'([^']+)/).shift.shift.gsub('.git', '')
  s.date     = Time.now

  s.authors  = ['Stan Angeloff']
  s.email    = ['stanimir@angeloff.name']
  s.homepage = 'https://github.com/StanAngeloff/compass-magick'

  s.has_rdoc = true

  s.require_paths = ['lib']

  s.add_runtime_dependency('compass',    '~> 0.11.beta.5')
  s.add_runtime_dependency('chunky_png', '~> 1.1.0')

  s.add_development_dependency('rspec',  '~> 2.0.0')

  s.files      = ['README.md', 'LICENSE.md']
  s.files     += Dir.glob('lib/**/*.*')
  s.files     += Dir.glob('extras/**/*.*')
  s.test_files = Dir.glob('spec/**/*.*')
end
