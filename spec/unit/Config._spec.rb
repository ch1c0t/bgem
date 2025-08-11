require 'helper'

describe Bgem::Config do
  class IOStub
    def read config_file
      fail unless config_file == '_some_config.rb'

      <<~S
        entry 'entry.rb'
        output 'out.rb'
        inside 'a', 'b'
      S
    end
  end

  class IOStubForDefaultEntry
    def read _config_file
      <<~S
        output 'output.rb'
        inside 'a', 'b'
      S
    end
  end

  class IOStubForDefaultOutput
    def read _config_file
      <<~S
        entry 'entry.rb'
        inside 'a', 'b'
      S
    end
  end

  let(:config) { described_class.new '_some_config.rb' }

  it 'creates accessors' do
    stub_const 'IO',  IOStub.new

    expect(config).to be_a Bgem::Config
    expect(config.outputs).to be_an Array
    
    output = config.outputs[0]

    output.entry = 'e.rb'
    output.file = 'o.rb'
    output.scope = ['module M', 'class C']

    assert { output.entry == 'e.rb' }
    assert { output.file == 'o.rb' }
    assert { output.scope == ['module M', 'class C'] }
  end

  it 'loads config file' do
    stub_const 'IO',  IOStub.new

    output = config.outputs[0]

    assert { output.entry == 'entry.rb' }
    assert { output.file == 'out.rb' }
    assert { output.scope == ['a', 'b'] }
  end
end
