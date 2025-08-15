shared_examples 'crystal_bin' do
  it 'creates src/bin/ and files in it' do
    src_bin = Pathname 'src/bin'
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
end
