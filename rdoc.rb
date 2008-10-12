require 'rake'
require 'rake/rdoctask'
require File.dirname(__FILE__) + "/support/set_default"

RDOC_DIRECTORY = "doc"

def doc_directory
  RDOC_DIRECTORY
end

raise_error_on :rdoc_title
raise_error_on :project_root

desc 'Generate documentation for the fixture_replacement plugin.'
Rake::RDocTask.new(:rdoc_without_analytics) do |rdoc|
  rdoc.rdoc_dir = doc_directory
  rdoc.title    = rdoc_title
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :rdoc => [:rdoc_without_analytics] do
  google_analytics = "#{project_root}/etc/google_analytics"
  rdoc_index = File.dirname(__FILE__) + "/#{doc_directory}/index.html"
  
  contents = File.read(rdoc_index) 
  contents.gsub!("</head>", "#{google_analytics}\n</head>")

  File.open(rdoc_index, "r+") do |file|
    file.write(contents)
  end
end

task :rerdoc => [:clobber_rdoc, :rdoc]
task :clobber_rdoc => [:clobber_rdoc_without_analytics]

def create_doc_directory
  unless File.exists?(doc_directory)
    `mkdir doc`
  end  
end

task :create_doc_directory do
  create_doc_directory
end
