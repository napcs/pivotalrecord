# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pivotalrecord}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Hogan"]
  s.date = %q{2009-08-12}
  s.email = %q{brianhogan@naopcs.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Rakefile", "spec/pivotal", "spec/pivotal/iteration_spec.rb", "spec/pivotal/project_spec.rb", "spec/pivotal/story_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "lib/pivotal", "lib/pivotal/base.rb", "lib/pivotal/configuration.rb", "lib/pivotal/iteration.rb", "lib/pivotal/iteration_collection.rb", "lib/pivotal/project.rb", "lib/pivotal/story.rb", "lib/pivotal.rb", "README.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://www.napcs.com}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pivotalrecord}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple ActiveRecord-style interface for PivotalTracker}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.0.3"])
      s.add_runtime_dependency(%q<xml-simple>, ["~> 1.0.12"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 2.0.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, ["~> 1.0.3"])
      s.add_dependency(%q<xml-simple>, ["~> 1.0.12"])
      s.add_dependency(%q<activesupport>, ["~> 2.0.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, ["~> 1.0.3"])
    s.add_dependency(%q<xml-simple>, ["~> 1.0.12"])
    s.add_dependency(%q<activesupport>, ["~> 2.0.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
