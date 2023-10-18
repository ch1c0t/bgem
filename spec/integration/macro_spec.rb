require 'helper'

describe :integration do
  it do
    target = Bgem.run 'spec/integration/test_macro/bgem/config.rb'
    source = <<~S
      module Main

        puts 'ext: rb, type: some, name: A'

        class Cl
        end

        module Mo
        end
      end
    S

    expect(target.file.read).to eq source
  end
end
