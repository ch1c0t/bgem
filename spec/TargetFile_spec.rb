require 'helper'
require 'tempfile'

describe Bgem::TargetFile do
  it do
    tf = described_class.new Tempfile.new, "['module M', 'class C']"
    assert { tf.is_a? described_class }

    tf.write 'smt'

    source = <<~S
      module M
        class C
          smt
        end
      end
    S

    assert { tf.instance_variable_get(:@path).read == source }
  end
end
