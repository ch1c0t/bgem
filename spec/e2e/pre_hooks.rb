shared_examples 'pre_hooks' do
  it 'produces an output' do
    file = 'lib/main.rb'
    expect(File.exist? file).to be_truthy
    output = IO.read file
    
    expected = <<~S
      module Main
        module Preamble
          class Inside < Ancestor
            puts 'from Inside:Ancestor.class.rb'
          end
        
          puts 'from Preamble.module.rb'
        end

        p Preamble

        module AfterMain
          puts 'from AfterMain.module.rb'
        end
      end
    S

    expect(output).to eq expected
  end
end
