require 'helper'
require 'tempfile'
require 'ostruct'

describe Bgem::TargetFile do
  it do
    config = OpenStruct.new output: Tempfile.new,
      scope: ['class C', 'module M']
    target = described_class.new config

    target.write 'smt'

    source = <<~S
      module M
        class C
          smt
        end
      end
    S

    assert { target.file.read == source }
  end
end
