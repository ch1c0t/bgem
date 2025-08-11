VERSION = '0.1.1'

require 'pathname'
require 'string/indent'

INDENT = 2

class << self
  def run config_file = "#{Dir.pwd}/bgem/config.rb"
    config = Config.new config_file

    writes = config.outputs.map do |output|
      write = Write.new output
      write[Output.new(output.entry).to_s]
      write
    end

    writes[0]
  end
end
