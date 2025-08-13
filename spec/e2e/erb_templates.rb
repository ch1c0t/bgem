shared_examples 'erb_templates' do
  it 'makes Some.erb callable' do
    output = `ruby lib/main.rb`
    expect(output).to eq "from a and from b\n"
  end
end
