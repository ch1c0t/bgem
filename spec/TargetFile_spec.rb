require 'helper'
require 'tempfile'

describe Bgem::TargetFile do
  it do
    target = described_class.new Tempfile.new, ['class C', 'module M']

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
