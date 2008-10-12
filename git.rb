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

