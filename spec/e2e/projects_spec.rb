require_relative 'setup'

projects = Dir['spec/e2e/projects/*'].each do |project_directory|
  project_name = File.basename project_directory 
  describe project_directory do
    before :all do
      test_path = "#{PATH}/#{project_name}"
      `cp -r #{project_directory} #{test_path}`
      Dir.chdir test_path
      `#{BGEM}`
    end

    it 'outputs' do
      puts Dir.pwd
    end

    require_relative project_name
    it_behaves_like project_name

    after :all do
      Dir.chdir BGEM_DIR
    end
  end
end
