require 'rake'

path = File.dirname(__FILE__)
require "#{path}/test"
require "#{path}/rdoc"
require "#{path}/spec"
require "#{path}/rubyforge"
require "#{path}/specdoc"
require "#{path}/rspec_rcov"
require "#{path}/flog"
require "#{path}/git"

# DOCS - Make this more generic

desc 'Create the specdoc + rdoc'
task :build_docs => [:rerdoc, :specdoc, :rcov, :flog_to_disk]
