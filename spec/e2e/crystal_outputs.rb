shared_examples 'crystal_outputs' do
  let(:src) { Pathname 'src' }
  let(:tmux_file) { src.join 'tmux.cr' }

  it 'creates src/tmux.cr' do
    expect(tmux_file.file?).to be_truthy

    expected = <<~S.chomp
      module Tmux

        class Project
          def self.create_and_enter(path)
            puts "Project in \#{path}"
          end
        end
      end
    S

    expect(tmux_file.read).to eq expected
  end

  it 'uses src.source/PascalCase.require to make src/pascal_case.cr' do
    file = src.join 'pascal_case.cr'
    expected = <<~S.chomp
      require "colorize"
      require "./tmux"

      module PascalCase
        puts Tmux.to_s.colorize.blue
      end
    S

    expect(file.read).to eq expected
  end
end
