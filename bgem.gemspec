Gem::Specification.new do |g|
  g.name    = 'bgem'
  g.files   = `git ls-files`.split($/)
  g.version = '0.0.0'
  g.summary = 'Build gems without too much hassle.'
  g.authors = ['Anatoly Chernow']

  g.executables << 'bgem'
end
