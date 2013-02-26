# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pry-coolline"
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Mair (banisterfiend)"]
  s.date = "2012-04-03"
  s.description = "Live syntax-highlighting for the Pry REPL"
  s.email = "jrmair@gmail.com"
  s.files = [".gemtest", ".gitignore", ".yardopts", "CHANGELOG", "LICENSE", "README.md", "Rakefile", "lib/pry-coolline.rb", "lib/pry-coolline/version.rb", "pry-coolline.gemspec", "test/test.rb"]
  s.homepage = "https://github.com/pry/pry-coolline"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "1.8.16"
  s.summary = "Live syntax-highlighting for the Pry REPL"
  s.test_files = ["test/test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<coolline>, ["~> 0.2.0"])
    else
      s.add_dependency(%q<coolline>, ["~> 0.2.0"])
    end
  else
    s.add_dependency(%q<coolline>, ["~> 0.2.0"])
  end
end
