require 'rake'
require 'rake/rdoctask'

RDOC_DIRECTORY = "doc"

def doc_directory
  RDOC_DIRECTORY
end

desc 'Generate documentation for the fixture_replacement plugin.'
Rake::RDocTask.new(:rdoc_without_analytics) do |rdoc|
  rdoc.rdoc_dir = doc_directory
  rdoc.title    = 'FixtureReplacement'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :rdoc => [:rdoc_without_analytics] do
  google_analytics = File.read(File.dirname(__FILE__) + "/etc/google_analytics")
  rdoc_index = File.dirname(__FILE__) + "/#{doc_directory}/index.html"
  
  contents = File.read(rdoc_index) 
  contents.gsub!("</head>", "#{google_analytics}\n</head>")

  File.open(rdoc_index, "r+") do |file|
    file.write(contents)
  end
end

task :rerdoc => [:clobber_rdoc, :rdoc]
task :clobber_rdoc => [:clobber_rdoc_without_analytics]
