require 'helper'

describe 'Bgem directives' do
  it do
    target = Bgem.run 'spec/test_pre_and_post/bgem/config.rb'
    output = target.file.read.lines

    assert { output[0] == "module Bgem\n" }
    assert { output[1] == "  module Preamble\n" }
    assert { output[2] == "    preamble\n" }

    assert { output[28] == "  class Config\n" }
    assert { output[29] == "    def initialize config_file\n" }
  end
end
