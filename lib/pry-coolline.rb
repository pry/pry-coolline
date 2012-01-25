# pry-coolline.rb
# (C) John Mair (banisterfiend); MIT license

require 'pry'
require "pry-coolline/version"

begin
  require 'coolline'

  Pry.config.input = Coolline.new do |cool|
    cool.word_boundaries = [" ", "\t", ",", ";", ".", '"', "'", "`", "<", ">",
                            "=", ";", "|", "{", "}", "(", ")", "-"]

    cool.history_file = Coolline::NullFile

    cool.transform_proc = proc do
      CodeRay.scan(cool.line, :ruby).term
    end
  end

  Pry.config.auto_indent = false
rescue LoadError
end if ENV["TERM"] != "dumb"

