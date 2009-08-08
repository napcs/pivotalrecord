

require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

task :default => :spec

require "spec"
require "spec/rake/spectask"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(--format specdoc --colour)
  t.libs = ["spec"]
end

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  
  # Change these as appropriate
  s.name              = "pivotalrecord"
  s.version           = "0.0.1"
  s.summary           = "Simple ActiveRecord-style interface for PivotalTracker"
  s.author            = "Brian Hogan"
  s.email             = "brianhogan@naopcs.com"
  s.homepage          = "http://www.napcs.com"

  s.has_rdoc          = true
  
  # You should probably have a README of some kind. Change the filename
  # as appropriate
   s.extra_rdoc_files  = %w(README.rdoc)
   s.rdoc_options      = %w(--main README.rdoc)

  # Add any extra files to include in the gem (like your README)
  s.files             = %w(Rakefile) + Dir.glob("{spec,lib}/**/*")
   
  s.require_paths     = ["lib"]
  
  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  s.add_dependency("rest-client", "~> 1.0.3")
  s.add_dependency("xml-simple", "~> 1.0.12")
  s.add_dependency("activesupport", "~> 2.0.2")
  
  s.add_development_dependency("rspec") # add any other gems for testing/development

  # If you want to publish automatically to rubyforge, you'll may need
  # to tweak this, and the publishing task below too.
  s.rubyforge_project = "pivotalrecord"
end

# This task actually builds the gem. We also regenerate a static 
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
  
  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# Generate documentation
Rake::RDocTask.new do |rd|
  
  rd.rdoc_files.include("lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end

# If you want to publish to RubyForge automatically, here's a simple 
# task to help do that. If you don't, just get rid of this.
# Be sure to set up your Rubyforge account details with the Rubyforge
# gem; you'll need to run `rubyforge setup` and `rubyforge config` at
# the very least.
begin
  require "rake/contrib/sshpublisher"
  namespace :rubyforge do
    
    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]
    
    namespace :release do
      desc "Release a new version of this gem"
      task :gem => [:package] do
        require 'rubyforge'
        rubyforge = RubyForge.new
        rubyforge.configure
        rubyforge.login
        rubyforge.userconfig['release_notes'] = spec.summary
        path_to_gem = File.join(File.dirname(__FILE__), "pkg", "#{spec.name}-#{spec.version}.gem")
        puts "Publishing #{spec.name}-#{spec.version.to_s} to Rubyforge..."
        rubyforge.add_release(spec.rubyforge_project, spec.name, spec.version.to_s, path_to_gem)
      end
    
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )
 
        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/pivotalrecord/" # Should be the same as the rubyforge project name
        local_dir = 'rdoc'
 
        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end