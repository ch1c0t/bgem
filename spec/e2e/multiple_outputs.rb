shared_examples 'multiple_outputs' do
  it 'produces lib/bgem.rb' do
    output = IO.read 'lib/bgem.rb'
    expected = <<~S
      puts 'from Bgem.module.rb'
    S

    expect(output).to eq expected
  end

  it 'produces lib/bgem/crystal.rb' do
    output = IO.read 'lib/bgem/crystal.rb'
    expected = <<~S
      puts 'from Crystal.module.rb'
    S

    expect(output).to eq expected
  end
end
