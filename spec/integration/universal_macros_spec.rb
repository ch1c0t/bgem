require 'helper'

describe :integration do
  it do
    target = Bgem.run 'spec/integration/test_macro2/bgem/config.rb'
    source = <<~S
      module Main

        puts 'ext: rb, type: some2, name: A'

        class Cl
        end

        module Mo
        end

        puts 'ext: erb, type: some, name: NonDefault'
      end
    S

    expect(target.file.read).to eq source
  end
end
