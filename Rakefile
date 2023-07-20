task :build do
  sh 'bundle exec bgem'
end

task :test do
  sh 'bundle exec rspec'
end

task :dev do
  sh 'bundle exec rerun -p "src/**/*" bundle exec rake'
end

task :default => [:build, :test]
