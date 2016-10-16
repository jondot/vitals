require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:spec) do |t|
  t.libs << 'spec'
  t.libs << 'lib'
  t.test_files = FileList['spec/**/*_spec.rb']
end

Rake::TestTask.new(:multiverse) do |t|
  t.libs << 'integration'
  t.libs << 'spec'
  t.libs << 'lib'
  t.test_files = FileList['integration/multiverse_spec.rb']
end

Rake::TestTask.new(:bench) do |t|
  t.libs << 'spec'
  t.libs << 'lib'
  t.test_files = FileList['spec/**/*_bench.rb']
end

task default: :spec
