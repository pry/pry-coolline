# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require 'pry-coolline/version'

Gem::Specification.new do |s|
  s.name = "pry-coolline"

  s.version = PryCoolline::VERSION
  s.date = Time.now.strftime '%Y-%m-%d'

  s.summary = "Live syntax-highlighting for the Pry REPL"
  s.description = s.summary

  s.email  = 'jrmair@gmail.com'
  s.author = "John Mair (banisterfiend)"

  s.license = "MIT"

  s.homepage = "https://github.com/pry/pry-coolline"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")

  s.add_dependency("coolline","~>0.5")
  s.add_development_dependency("riot")
  s.add_development_dependency 'rake', "~> 10.0"
  s.required_ruby_version = '>= 1.9.2'
  s.require_path = 'lib'
end
