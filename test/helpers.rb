$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))

require 'riot'
require 'pry-coolline'

Riot.reporter = Riot::PrettyDotMatrixReporter
