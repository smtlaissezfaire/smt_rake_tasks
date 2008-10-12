require 'rake'
require 'rake/contrib/rubyforgepublisher'

RUBYFORGE_USERNAME = "smtlaissezfaire"
RUBYFORGE_PROJECT_NAME = "replacefixtures"

desc 'Publish the website, building the docs first'
task :publish_website => [:build_docs] do
  publisher = Rake::SshDirPublisher.new(
    "#{RUBYFORGE_USERNAME}@rubyforge.org",
    "/var/www/gforge-projects/#{RUBYFORGE_PROJECT_NAME}/",
    "doc"
  )
  publisher.upload
end
