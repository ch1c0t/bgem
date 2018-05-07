require 'helper'

describe Bgem::Write do
  let(:file) { Tempfile.new }

  let :config do
    OpenStruct.new output: file,
      scope: ['class C', 'module M']
  end

  let(:write) { described_class.new config }

  it 'writes newlines at the end' do
    config = OpenStruct.new output: file
    write = described_class.new config

    write['smt']
    expect(file.read).to eq "smt\n"
  end

  it 'writes to the nested scopes' do
    write['smt']

    source = <<~S
      module M
        class C
          smt
        end
      end
    S

    expect(file.read).to eq source
  end

  it 'creates the directory for the file' do
    file, dirname = Tempfile.new, double
    file.define_singleton_method(:dirname) { dirname }
    write.instance_variable_set :@file, file

    expect(dirname).to receive :mkpath
    write['smt']
  end
end
