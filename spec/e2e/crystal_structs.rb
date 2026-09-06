shared_examples 'crystal_structs' do
  let(:src) { Pathname 'src' }

  it 'creates a struct' do
    file = src.join 'command_result.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
struct CommandResult
  include YAML::Serializable
  
  property command : String
  property stdout : String 
  property stderr : String 
  property exit_code : Int32
  
  def initialize(@command, @stdout, @stderr, @exit_code)
  end
end
    S
    expect(file.read).to eq expected
  end

  it 'creates an abstract struct' do
    file = src.join 'shape.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
abstract struct Shape
  abstract def area : Float64
end
    S
    expect(file.read).to eq expected
  end

  it 'creates a struct that inherits from the abstract struct' do
    file = src.join 'circle.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
struct Circle < Shape
  def area : Float64
    Math::PI * @radius ** 2
  end
end
    S
    expect(file.read).to eq expected
  end
end
