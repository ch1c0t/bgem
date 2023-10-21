require_relative 'setup'

describe :e2e do
  it 'has a version' do
    output = `#{bgem} -v`
    expect(output.chomp).to eq Bgem::VERSION
  end
end
