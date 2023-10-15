require 'helper'

describe :integration do
  it do
    target = Bgem.run 'spec/integration/test_erb/bgem/config.rb'
    output = `ruby #{target.file}`

    expect(output).to eq "from a and from b\n"
  end
end
