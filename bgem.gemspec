Gem::Specification.new do |g|
  g.name    = 'bgem'
  g.files   = ['lib/bgem.rb', 'bin/bgem']
  g.version = '0.0.13'
  g.summary = 'A tool to build single-file Ruby gems with less ends.'
  g.authors = ['Anatoly Chernov']
  g.license = 'ISC'
  g.homepage = 'https://github.com/ch1c0t/bgem'

  g.executables << 'bgem'

  g.add_dependency 'string-indent', '~> 0.0.1'
end
