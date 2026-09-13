shared_examples 'crystal_order' do
  let(:src) { Pathname 'src' }

  it 'orders classed as defined in the order file' do
    file = src.join 'project.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
module Project

  abstract class Project
  end

  abstract class CrystalProject < Project
    abstract def task_prefixes : Array(String)
  end

  class CrystalBgemProject < CrystalProject
  end

  class CrystalShardProject < CrystalProject
  end
end
    S
    expect(file.read).to eq expected
  end
end
