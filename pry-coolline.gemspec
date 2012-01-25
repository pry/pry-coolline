# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pry-coolline}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{John Mair (banisterfiend)}]
  s.date = %q{2012-01-25}
  s.description = %q{Live syntax-highlighting for the Pry REPL}
  s.email = %q{jrmair@gmail.com}
  s.files = [%q{.gemtest}, %q{.gitignore}, %q{.yardopts}, %q{CHANGELOG}, %q{LICENSE}, %q{README.md}, %q{Rakefile}, %q{lib/pry-coolline.rb}, %q{lib/pry-coolline/version.rb}, %q{test/test.rb}]
  s.homepage = %q{https://github.com/pry/pry-coolline}
  s.require_paths = [%q{lib}]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Live syntax-highlighting for the Pry REPL}
  s.test_files = [%q{test/test.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<coolline>, ["~> 0.1.0"])
      s.add_runtime_dependency(%q<io-console>, ["~> 0.3.0"])
    else
      s.add_dependency(%q<coolline>, ["~> 0.1.0"])
      s.add_dependency(%q<io-console>, ["~> 0.3.0"])
    end
  else
    s.add_dependency(%q<coolline>, ["~> 0.1.0"])
    s.add_dependency(%q<io-console>, ["~> 0.3.0"])
  end
end
