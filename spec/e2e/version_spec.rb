require_relative 'setup'

describe :e2e do
  it 'has a version' do
    output = `#{BGEM} -v`
    expect(output.chomp).to eq Bgem::VERSION
  end
end
