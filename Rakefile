$:.unshift 'lib'

dlext = Config::CONFIG['DLEXT']
direc = File.dirname(__FILE__)

PROJECT_NAME = "pry-coolline"

require 'rake/clean'
require 'rake/gempackagetask'
require "#{PROJECT_NAME}/version"

CLOBBER.include("**/*~", "**/*#*", "**/*.log")
CLEAN.include("**/*#*", "**/*#*.*", "**/*_flymake*.*", "**/*_flymake",
              "**/*.rbc", "**/.#*.*")

def apply_spec_defaults(s)
  s.name = PROJECT_NAME
  s.summary = "Live syntax-highlighting for the Pry REPL"
  s.version = PryCoolline::VERSION
  s.date = Time.now.strftime '%Y-%m-%d'
  s.author = "John Mair (banisterfiend)"
  s.email = 'jrmair@gmail.com'
  s.description = s.summary
  s.add_dependency("coolline","~>0.2.0")
  s.add_dependency("io-console","~>0.3.0")
  s.required_ruby_version = '>= 1.9.2'
  s.require_path = 'lib'
  s.homepage = "https://github.com/pry/pry-coolline"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end

task :default => :test

desc "run pry with plugin enabled"
task :pry do
  exec("pry -I#{direc}/lib/ -r #{direc}/lib/#{PROJECT_NAME}")
end

desc "run tests"
task :test do
  sh "bacon -Itest -rubygems -a"
end

desc "Show version"
task :version do
  puts "PryCoolline version: #{PryCoolline::VERSION}"
end

desc  "Generate gemspec file"
task :gemspec => "ruby:gemspec"

namespace :ruby do
  spec = Gem::Specification.new do |s|
    apply_spec_defaults(s)
    s.platform = Gem::Platform::RUBY
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
  end

  desc  "Generate gemspec file"
  task :gemspec do
    File.open("#{spec.name}.gemspec", "w") do |f|
      f << spec.to_ruby
    end
  end
end

desc "shorthand for :gems task"
task :gem => :gems

desc "build all platform gems at once"
task :gems => [:clean, :rmgems, "ruby:gem"]

desc "remove all platform gems"
task :rmgems => ["ruby:clobber_package"]

desc "build and push latest gems"
task :pushgems => :gems do
  chdir("#{File.dirname(__FILE__)}/pkg") do
    Dir["*.gem"].each do |gemfile|
      sh "gem push #{gemfile}"
    end
  end
end


