module PryCoolline
  Wrapper = Struct.new(:cool) do
    def readline(prompt)
      cool.readline propt
    end

    def completing_proc=(proc)
      cool.completing_proc = proc do
        proc.call cool.completed_word
      end
    end
  end

  module_function

  # @return [Coolline]
  def make_coolline
    Coolline.new do |cool|
      cool.word_boundaries = [" ", "\t", ",", ";", '"', "'", "`", "<", ">",
                              "=", ";", "|", "{", "}", "(", ")", "-"]

      # bring saved history into coolline
      cool.history_file = File.expand_path(Pry.config.history.file)

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
  end

  # @return [Wrapper] An object usable as an input object for Pry.
  def make_input
    Wrapper.new make_coolline
  end
end
