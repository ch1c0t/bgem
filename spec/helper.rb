require 'hobby/devtools/rspec_helper'
require 'bgem'

INPUT  = Pathname "spec/test_src/Main.module.rb"
OUTPUT = Pathname "/tmp/rspec.bgem.#{$$}/output.rb"

module Bgem
  module CLI
    def self.parse_argv
      { input: INPUT, output: OUTPUT }
    end
  end
end

Bgem::CLI.run
