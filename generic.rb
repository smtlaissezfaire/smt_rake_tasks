require 'rake'

path = File.dirname(__FILE__)
require "#{path}/test"
require "#{path}/rdoc"
require "#{path}/spec"
require "#{path}/rubyforge"


# RDOC

def create_doc_directory
  unless File.exists?(doc_directory)
    `mkdir doc`
  end  
end

task :create_doc_directory do
  create_doc_directory
end

# Specdoc

desc "Create the html specdoc"
Spec::Rake::SpecTask.new(:specdoc => :create_doc_directory) do |t|
  t.spec_opts = ["--format", "html:doc/specdoc.html"]
end

# rcov through rspec

require 'spec/rake/verify_rcov'

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec', "--exclude", "gems"]
  t.rcov_dir = "doc/rcov"
end

# DOCS - Make this more generic

desc 'Create the specdoc + rdoc'
task :build_docs => [:rerdoc, :specdoc, :rcov, :flog_to_disk]


# FLOG Task

desc "Feel the pain of my code, and submit a refactoring patch"
task :flog do
  puts %x(find lib | grep ".rb$" | xargs flog)
end

task :flog_to_disk => :create_doc_directory do
  puts "Flogging..."
  %x(find lib | grep ".rb$" | xargs flog > doc/flog.txt)
  puts "Done Flogging...\n"
end

# GIT

namespace :git do
  def have_git?
    File.exists?(".git") && `which git`.any?
  rescue
    false
  end
  
  def get_git_revision
    if have_git?
      `git rev-list HEAD`.split("\n").first
    else
      "UNKNOWN"
    end
  end
  
  desc "Print the current git revision"
  task :revision do
    puts get_git_revision
  end
  
  PROJECT_PATHNAME = "fixture_replacement"
  PROJECT_VERSION_FILE_PATH = "lib/#{PROJECT_PATHNAME}/version.rb"
  
  task :substitute_revision do
    def version_file
      "#{File.dirname(__FILE__)}/#{PROJECT_VERSION_FILE_PATH}"
    end
    
    def replace_in_file(filename, s, r)
      File.open(filename, "r+") do |file|
        lines = file.readlines.map do |line|
          line.gsub(s) { r }
        end
        file.rewind
        file.write(lines)
      end
    end
    
    replace_in_file(version_file, /REVISION\s+\=.*/, "REVISION = '#{get_git_revision}'")
  end
end

desc "Set the build revision number for versioning"
task :set_revision_number => ["git:substitute_revision"]

