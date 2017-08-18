require 'helper'

describe do
  it do
    target = Bgem.run 'spec/test_pre_and_post/bgem/config.rb'
    output = target.file.read.lines

    assert { output[0] == "module Bgem\n" }
  end
end
