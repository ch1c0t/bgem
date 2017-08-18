require 'helper'

describe do
  it do
    target = Bgem.run 'spec/test_pre_and_post/bgem/config.rb'
    output = target.file.read.lines

    assert { output[0] == "module Bgem\n" }
    assert { output[1] == "  module Preamble\n" }
    assert { output[2] == "    preamble\n" }
  end
end
