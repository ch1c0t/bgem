def self.run
  options = parse_argv
  target = TargetFile.new *options[:output], options[:scope]
  target.write SourceFile.new(*options[:input]).to_s
end

def self.parse_argv
  ARGV.map do |string|
    key, _colon, value = string.partition ':'
    [key.to_sym, value]
  end.to_h
end
