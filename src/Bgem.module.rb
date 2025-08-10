VERSION = '0.1.1'

require 'pathname'
require 'string/indent'

INDENT = 2

class << self
  def run config_file = "#{Dir.pwd}/bgem/config.rb"
    config = Config.new config_file
    write = Write.new config
    write[Output.new(config.entry).to_s]
    write
  end
end
