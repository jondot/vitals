require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList['spec/**/*_spec.rb'].reject{|f| f.start_with?('spec/multiverse')}
end

Rake::TestTask.new(:bench) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList['spec/**/*_bench.rb'].reject{|f| f.start_with?('spec/multiverse')}
end

task :default => :spec
