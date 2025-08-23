Gem::Specification.new do |g|
  g.name    = 'bgem'
  g.files   = ['bin/bgem', 'lib/bgem.rb', 'lib/bgem/crystal.rb']
  g.version = '0.2.2'
  g.summary = 'To make anything from macros.'
  g.authors = ['Anatoly Chernov']
  g.license = 'ISC'
  g.homepage = 'https://github.com/ch1c0t/bgem'

  g.executables << 'bgem'

  g.add_dependency 'string-indent', '~> 0.0.1'
end
