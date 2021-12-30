$:.unshift 'lib'

PROJECT_NAME = "pry-coolline"
direc = File.dirname(__FILE__)

require 'rake/clean'
require "#{PROJECT_NAME}/version"

CLOBBER.include("**/*~", "**/*#*", "**/*.log")
CLEAN.include("**/*#*", "**/*#*.*", "**/*_flymake*.*", "**/*_flymake",
              "**/*.rbc", "**/.#*.*")

task :default => :test

desc "run pry with plugin enabled"
task :pry do
  exec("pry -I#{direc}/lib/ -r #{direc}/lib/#{PROJECT_NAME}")
end

desc "run tests"
task :test do
  ruby "test/run_all.rb"
end

desc "Show version"
task :version do
  puts "PryCoolline version: #{PryCoolline::VERSION}"
end
