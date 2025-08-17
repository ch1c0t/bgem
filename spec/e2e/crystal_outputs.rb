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
end
