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

    config.entry = 'e.rb'
    config.output = 'o.rb'
    config.scope = ['module M', 'class C']

    assert { config.entry == 'e.rb' }
    assert { config.output == 'o.rb' }
    assert { config.scope == ['module M', 'class C'] }
  end

  it 'loads config file' do
    stub_const 'IO',  IOStub.new

    assert { config.entry == 'entry.rb' }
    assert { config.output == 'out.rb' }
    assert { config.scope == ['a', 'b'] }
  end

  it 'gets the default entry from SOURCE_FILE' do
    stub_const 'IO',  IOStubForDefaultEntry.new
    stub_const 'Bgem::SOURCE_FILE', 'default_source_file.rb'

    expect(config.entry).to eq 'default_source_file.rb'
  end

  it 'sets the default output to output.rb' do
    stub_const 'IO',  IOStubForDefaultOutput.new
    expect(config.output).to eq 'output.rb'
  end
end
