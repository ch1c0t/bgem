shared_examples 'crystal_classes' do
  let(:src) { Pathname 'src' }

  it 'creates an abstract class' do
    file = src.join 'ac.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
abstract class AC
  abstract def self.detect?(dir : String) : Bool
  abstract def watch_paths : Array(String)
end
    S
    expect(file.read).to eq expected
  end

  it 'creates an abstract class that inherits from other abstract class' do
    file = src.join 'crystal_project.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
abstract class CrystalProject < Project
  abstract def task_prefixes : Array(String)
end
    S
    expect(file.read).to eq expected
  end
end
