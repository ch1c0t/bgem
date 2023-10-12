require 'helper'

describe :integration do
  it do
    target = Bgem.run 'spec/integration/erb_src/bgem/config.rb'
    output = `ruby #{target.file}`

    expect(output).to eq "from a and from b\n"
  end
end
