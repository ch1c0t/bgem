Gem::Specification.new do |g|
  g.name    = 'bgem'
  g.files   = ['lib/bgem.rb', 'bin/bgem']
  g.version = '0.0.11'
  g.summary = 'Build gems without too much hassle.'
  g.authors = ['Anatoly Chernow']

  g.executables << 'bgem'

  g.add_dependency 'string-indent', '>=0.0.1'
end
