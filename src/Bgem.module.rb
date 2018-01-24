require 'pathname'

class ::String
  def indent number
    lines.map { |line| "#{' '*number}#{line}" }.join
  end
end

INDENT = 2
SOURCE_FILE = Dir['src/*.rb'][0]
CONFIG_FILE = "#{Dir.pwd}/bgem/config.rb"

class << self
  def run config_file = CONFIG_FILE
    config = Config.new config_file
    target = TargetFile.new config.output, config.scope
    target.write SourceFile.new(config.entry).to_s
    target
  end
end
