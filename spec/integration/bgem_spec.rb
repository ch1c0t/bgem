require 'helper'

describe :integration do
  it do
    target = Bgem.run 'spec/integration/test_src/bgem/config.rb'
    output = target.file.read.lines

    assert { output[0] == "module Main\n" }
    assert { output[1] == "  module Before\n" }
    assert { output[2] == "    class Inside < Ancestor\n" }
    assert { output[3] == "      in inside\n" }
  end

  it do
    target = Bgem.run 'spec/integration/test_inside_src/bgem/config.rb'

    source = <<~S
      module M
        class C
          class Main
            in Main.rb
          end
        end
      end
    S

    assert { target.file.read == source }
  end
end
