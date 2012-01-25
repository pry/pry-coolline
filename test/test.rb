direc = File.dirname(__FILE__)

require 'rubygems'
require "#{direc}/../lib/pry-coolline"
require 'bacon'

puts "Testing pry-coolline version #{PryCoolline::VERSION}..." 
puts "Ruby version: #{RUBY_VERSION}"

describe PryCoolline do
end

