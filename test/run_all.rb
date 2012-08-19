require File.expand_path("helpers.rb", File.dirname(__FILE__))

Dir.glob(File.join(File.dirname(__FILE__), "**/*_test.rb")) do |file|
  load file
end
