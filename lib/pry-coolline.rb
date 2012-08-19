# pry-coolline.rb
# (C) John Mair (banisterfiend); MIT license

require 'pry'
require 'pry-coolline/version'

Pry.config.coolline_paren_matching ||= true

Pry.config.coolline_matched_paren    ||= "\e[42m"
Pry.config.coolline_mismatched_paren ||= "\e[41m"

begin
  require 'coolline'
  require 'pry-coolline/paren_match'

  Pry.config.input = Coolline.new do |cool|
    cool.word_boundaries = [" ", "\t", ",", ";", '"', "'", "`", "<", ">",
                            "=", ";", "|", "{", "}", "(", ")", "-"]

    # bring saved history into coolline
    cool.history_file = Pry.config.history.file

    cool.transform_proc = proc do
      if Pry.color
        code = CodeRay.scan(cool.line, :ruby).term

        if Pry.config.coolline_paren_matching
          PryCoolline.apply_paren_matching(code, cool.pos)
        end

        code
      else
        cool.line
      end
    end
  end
rescue LoadError
end if ENV["TERM"] != "dumb"
