require 'helper'
require 'tempfile'
require 'ostruct'

describe Bgem::Write do
  it do
    config = OpenStruct.new output: Tempfile.new,
      scope: ['class C', 'module M']
    write = described_class.new config

    write['smt']

    source = <<~S
      module M
        class C
          smt
        end
      end
    S

    assert { write.file.read == source }
  end
end
