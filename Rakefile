task :build do
  sh 'bundle exec bgem'
end

task :test do
  sh 'bundle exec rspec'
end

task :default => [:build, :test]
