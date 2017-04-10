require 'pathname'

using Module.new {
  refine String do
    def indent number
      lines.map { |line| "#{' '*number}#{line}" }.join
    end
  end
}

INDENT = 2
SOURCE_FILE = Dir['src/*.rb'][0]
CONFIG_FILE = "#{Dir.pwd}/bgem/config.rb"

class << self
  def run config_file
    config = Config.new (config_file or CONFIG_FILE)
    target = TargetFile.new config.output, config.scope.reverse
    target.write SourceFile.new(config.entry).to_s
    target
  end
end
