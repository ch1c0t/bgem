require 'helper'

describe :integration do
  it do
    target = Bgem.run 'spec/integration/test_order/bgem/config.rb'
    source = <<~S
      module Main
        module D
        end

        module C
        end

        module A
        end

        module B
          puts 'from B'
        end

        puts 'from Main'

        module B
        end

        module A
        end

        module C
        end
      end
    S

    expect(target.file.read).to eq source
  end
end
