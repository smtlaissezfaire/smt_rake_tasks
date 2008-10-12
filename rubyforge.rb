require 'rake'
require 'rake/contrib/rubyforgepublisher'
require File.dirname(__FILE__) + "/support/set_default"

raise_error_on :rubyforge_username
raise_error_on :rubyforge_project_name

desc 'Publish the website, building the docs first'
task :publish_website => [:build_docs] do
  publisher = Rake::SshDirPublisher.new(
    "#{rubyforge_username}@rubyforge.org",
    "/var/www/gforge-projects/#{rubyforge_project_name}/",
    "doc"
  )
  publisher.upload
end
