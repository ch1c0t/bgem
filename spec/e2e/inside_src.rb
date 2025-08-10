shared_examples 'inside_src' do
  it 'has a bgem config' do
    expect(File.exist? 'bgem/config.rb').to be_truthy

    second_line = IO.readlines('bgem/config.rb')[1].chomp
    expect(second_line).to eq "inside 'class C', 'module M'"
  end

  it 'produces an output' do
    expect(File.exist? 'lib/output.rb').to be_truthy

    output = IO.read 'lib/output.rb'
    
    expected = <<~S
      module M
        class C
          class Main
            puts :main
          end
        end
      end
    S

    expect(output).to eq expected
  end
end
