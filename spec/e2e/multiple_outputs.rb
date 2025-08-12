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
      module Crystal
        puts 'from Crystal.module.rb'
      end
    S

    expect(output).to eq expected
  end
end
