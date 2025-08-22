shared_examples 'crystal_find' do
  let(:src) { Pathname 'src' }
  let(:src_bin) { src.join 'bin' }

  it 'creates find.cr from src.macros/' do
    file = src_bin.join 'tmux.select-or-create-within-current-project/find.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
module Find
  alias Value = Tmux::Session
  
  def self.in(options : Array(Value))
    options = Options.from options
    app = App.new options
    app.return_selected
  end

  class App
    def initialize(@options : Options)
    end
    
    def return_selected
      {:enter, @options["second"]}
    end
  end

  class Options
    def self.from(array : Array(Value))
      lines = array.map &.to_s
      hash = Hash.zip lines, array
      Options.new hash
    end
    
    @hash : Hash(String, Value)
    def initialize(@hash)
    end
    
    def as_lines
      @hash.keys
    end
    
    def [](key)
      @hash[key]
    end
  end
end
    S

    expect(file.read).to eq expected
  end
end
