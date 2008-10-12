require 'spec'
require 'spec/rake/verify_rcov'

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec', "--exclude", "gems"]
  t.rcov_dir = "doc/rcov"
end
