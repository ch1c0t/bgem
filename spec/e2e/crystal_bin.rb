shared_examples 'crystal_bin' do
  let(:src_bin) { Pathname 'src/bin' }

  it 'creates src/bin/ and files in it' do
    expect(src_bin.directory?).to be_truthy

    files = src_bin.glob('*.cr')
    basenames = files.map(&:basename).map(&:to_s)
    expect(basenames).to eq [
      "puts.cr",
      "tmux.close-project.cr",
      "tmux.project.cr",
      "tmux.select-or-create-within-current-project.cr",
    ]
  end

  it 'updates shard.yml with targets from src.source/bin/' do
    actual = IO.read 'shard.yml'
    expected = <<~S
      ---
      name: tmux.select-or-create
      version: 0.1.0
      authors:
      - Anatoly Chernov <chertoly@gmail.com>
      targets:
        puts:
          main: src/bin/puts.cr
        tmux.close-project:
          main: src/bin/tmux.close-project.cr
        tmux.project:
          main: src/bin/tmux.project.cr
        tmux.select-or-create-within-current-project:
          main: src/bin/tmux.select-or-create-within-current-project.cr
      dependencies:
        find:
          github: ch1c0t/crystal.find
        memoization:
          github: davidrunger/memoization
      crystal: ">= 1.15.1"
      license: MIT
    S

    expect(actual).to eq expected
  end

  it 'augments CLIs with version and help messages' do
    actual = src_bin.join('puts.cr').read
    expected = <<~S
      require "./puts/*"

      VERSION = "0.1.0"

      case ARGV.size
      when 1
        case ARGV[0]
        when "-v", "version", "--version"
          puts VERSION
          exit
        when "-h", "help", "--help"
          print_help
          exit
        end
      end

      puts "it works"
    S

    expect(actual).to eq expected

    help_file = src_bin.join('puts/print_help.cr')
    expect(help_file.file?).to be_truthy

    help_message = <<~HELP
      HELP_MESSAGE = <<-S
      A help message for puts.
      S

      def print_help
        puts HELP_MESSAGE
      end
    HELP
    expect(help_file.read).to eq help_message
  end
end
