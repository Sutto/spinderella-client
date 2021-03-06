# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{spinderella-client}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Darcy Laycock"]
  s.date = %q{2010-01-03}
  s.description = %q{A client library for spinderella (http://github.com/Sutto/spinderella)}
  s.email = %q{sutto@sutto.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/spinderella-client.rb",
     "lib/spinderella/client.rb",
     "lib/spinderella/client/broadcaster.rb",
     "lib/spinderella/client/subscriber.rb",
     "spinderella-client.gemspec",
     "test/helper.rb",
     "test/test_spinderella-client.rb"
  ]
  s.homepage = %q{http://github.com/Sutto/spinderella-client}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A Simple, Synchronous TCPSocket client for Spinderella}
  s.test_files = [
    "test/helper.rb",
     "test/test_spinderella-client.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<perennial>, [">= 1.2.4"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<perennial>, [">= 1.2.4"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<perennial>, [">= 1.2.4"])
  end
end

