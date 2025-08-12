shared_examples 'multiple_outputs' do
  it 'produces lib/bgem.rb' do
    output = IO.read 'lib/bgem.rb'
    expected = <<~S
      module Bgem
        puts 'from Bgem.module.rb'
      end
    S

    expect(output).to eq expected
  end

  it 'produces lib/bgem/crystal.rb' do
    output = IO.read 'lib/bgem/crystal.rb'
    expected = <<~S
      module Bgem
        module Crystal
          puts 'from Crystal.module.rb'
        end
      end
    S

    expect(output).to eq expected
  end

  it 'produces lib/m/c/nested.rb' do
    output = IO.read 'lib/m/c/nested.rb'
    expected = <<~S
      module M
        class C
          class Nested
            puts 'from Nested.class.rb'
          end
        end
      end
    S

    expect(output).to eq expected
  end
end
