MAIN_FILE = Dir['src/*.rb'][0]

def self.run
  options = parse_argv
  target = TargetFile.new (options[:output] || 'output.rb')
  target.write SourceFile.new(options[:input] || MAIN_FILE).to_s
end

def self.parse_argv
  ARGV.map do |string|
    key, _colon, value = string.partition ':'
    [key.to_sym, value]
  end.to_h
end
