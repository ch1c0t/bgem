VERSION = '0.2.2'

require 'pathname'
require 'string/indent'

INDENT = 2

class << self
  def run config_file = find_config
    config = Config.new config_file

    writes = config.outputs.map do |output|
      write = Write.new output
      write[Output.new(output.entry).to_s]
      write
    end

    writes[0]
  end

  def find_config
    ruby_config = Pathname "#{Dir.pwd}/bgem/config.rb"
    yaml_config = Pathname "#{Dir.pwd}/bgem/config.yml"

    return ruby_config if ruby_config.file?
    return yaml_config if yaml_config.file?
    fail "No config was found in #{Dir.pwd}"
  end
end
