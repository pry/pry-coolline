# -*- coding: utf-8 -*-
module PryCoolline
  module ParenMatch
    Pairs = {
      "(" => ")",
      "[" => "]",
      "{" => "}",
    }

    AnsiCode = %r{(\e\[\??\d+(?:[;\d]*)\w)}

    # A Token is a short chunk of code. This tokenizer only distinguishes three
    # kinds of token:
    #
    #   1. Tokens that open a pair (OpenToken)
    #   2. Tokens that close a pair (CloseToken)
    #   3. The rest of the code (StrToken)
    #
    # @attr [String]  str String covered by the token
    # @attr [Integer] pos Position in the initial code, character-wise,
    #   disregarding ANSI codes.
    # @attr [Integer] code_pos Position in the initial code, character-wise,
    #   including ANSI codes.
    Token = Struct.new(:str, :pos, :code_pos)

    OpenToken  = Class.new(Token)
    CloseToken = Class.new(Token)
    StrToken   = Class.new(Token)

    # Represents a pair that should be matched.
    #
    # @attr [OpenToken, nil]  open
    # @attr [CloseToken, nil] close
    Pair = Struct.new(:open, :close) do
      # @return [Boolean] True if the opening character and the closing
      #   characters are both present and match correctly.
      def correctly_matched?(pairs = Pairs)
        open and close and pairs[open.str] == close.str
      end

      # @return [Array<Array<Integer>>] Positions where the user can insert
      #   color indicators, in descending order so that String#insert can be
      #   used safely.
      #
      # @example
      #   insertion_positions.each do |before, after|
      #     string.insert after, clear_code
      #     string.insert before, background_code
      #   end
      def insertion_positions
        ary = []

        if close
          ary << [close.code_pos, close.code_pos + close.str.size]
        end

        if open
          ary << [open.code_pos, open.code_pos + open.str.size]
        end

        ary
      end
    end

    # This module contains the different kinds of AST nodes generated when
    # trying to match pairs of opening and closing characters.
    #
    module AST
      # The root of the AST tree.
      # @attr [Array<Leaf, DanglingClose, Node>] elements All the top-level
      #   nodes of the tree.
      Root = Struct.new(:elements) do
        # @param [Parser] parser Parser to get the tokens from
        def initialize(parser)
          self.elements = []

          while tok = parser.next_token
            case tok
            when OpenToken  then elements << Node.new(parser, tok)
            when StrToken   then elements << Leaf.new(tok)
            when CloseToken then elements << DanglingClose.new(tok)
            end
          end
        end

        # Finds the opening and closing tokens that should be matched at a
        # certain position in the string.
        #
        # It is assumed you can be looking for the closing parenthesis when on
        # the opening one, or for the opening one when selecting the character
        # that immediately follows it.
        #
        # @param [Integer] pos
        #
        # @return [Pair] An (open, close) pair. Notice both the opening and
        #   closing tokens coud be nil.
        def pair_at(pos)
          elements.each do |el|
            if pair = el.pair_at(pos)
              return pair
            end
          end

          Pair.new
        end
      end

      # A sequence of text on its own, that contains no parts of a pair.
      #
      # @attr [StrToken] tok
      Leaf = Struct.new(:tok) do
        # (see Root#pair_at)
        def pair_at(pos)
          nil
        end
      end

      # A top-level closing paren — meaning there's no matching opening
      # character.
      DanglingClose = Struct.new(:tok) do
        # (see Root#pair_at)
        def pair_at(pos)
          if pos == tok.pos + tok.str.size
            Pair.new(nil, tok)
          end
        end
      end

      # A block of code that was opened by a character, and may or may not (but
      # should!) have been closed by another token.
      #
      # @attr [OpenToken]       open
      # @attr [CloseToken, nil] close
      #
      # @attr [Array<Leaf, Node>] elements Other nodes within the opening and
      #   the closing tokens.
      Node = Struct.new(:open, :elements, :close) do
        def initialize(parser, open)
          self.elements = []
          self.open     = open

          while tok = parser.next_token and !tok.is_a?(CloseToken)
            case tok
            when OpenToken then elements << Node.new(parser, tok)
            when StrToken  then elements << Leaf.new(tok)
            end
          end

          self.close = tok # might be nil, which is okay
        end

        # (see Root#pair_at)
        def pair_at(pos)
          if pos == open.pos ||
              (close && pos == close.pos + close.str.size)
            Pair.new(open, close)
          else
            elements.each do |el|
              if pair = el.pair_at(pos)
                return pair
              end
            end

            nil
          end
        end
      end
    end

    class Parser
      # @param (see ParenMatch#pair_at)
      # @return [AST::Root]
      def self.parse(code, pairs = Pairs)
        new(code, pairs).parse
      end

      # @param (see ParenMatch#pair_at)
      def initialize(code, pairs = Pairs)
        @tokens = tokenize(code, pairs)
      end

      # @return [AST::Root]
      def parse
        AST::Root.new self
      end

      # Returns the next token found in the array and removes it.
      #
      # @return [Token] The next token, which will be removed from the queue.
      def next_token
        @tokens.shift
      end

      private

      # Generates token from a given chunk of code.
      #
      # ANSI codes are ignored, as if they were comments.
      #
      # @param (see ParenMatch#pair_at)
      # @return [Array<Token>]
      def tokenize(code, pairs)
        openers = Regexp.union(pairs.keys)
        closers = Regexp.union(pairs.values)

        token = Regexp.union(openers, closers, AnsiCode)

        tokens = []

        char_pos = pos = 0

        until pos == code.size
          old_pos = pos

          if m = match_at(code, AnsiCode, pos)
            pos = m.end(0)
          elsif m = match_at(code, openers, pos)
            tokens << OpenToken.new(m.to_s, char_pos, pos)
            pos = m.end(0)
            char_pos += pos - old_pos
          elsif m = match_at(code, closers, pos)
            tokens << CloseToken.new(m.to_s, char_pos, pos)
            pos = m.end(0)
            char_pos += pos - old_pos
          elsif m = code.match(token, pos)
            tokens << StrToken.new(code[pos...m.begin(0)], char_pos, pos)
            pos = m.begin(0)
            char_pos += pos - old_pos
          else
            tokens << StrToken.new(code[pos..-1], char_pos, pos)
            pos = code.size
          end
        end

        tokens
      end

      # @return [Matchdata, nil] Matchdata if the regexp matches the string at
      #   the specifed position, nil otherwise.
      def match_at(string, regexp, pos)
        if m = string.match(regexp, pos) and m.begin(0) == pos
          m
        end
      end
    end

    module_function
    # @param [String]  code
    # @param [Integer] pos Position of the selected character, disregarding ANSI
    #   codes.
    # @param [Hash<String, String>] pairs A hash mapping each opening character
    #   to a closing one.
    #
    # @return (see AST::Root#pair_at)
    def pair_at(code, pos, pairs = Pairs)
      Parser.parse(code, pairs).pair_at pos
    end
  end

  module_function

  # Adds paren matching code for the parens that are matched at a given
  # position. The color codes are determined using Pry.config.
  #
  # @param [String] code
  # @param [Integer] pos
  def apply_paren_matching(code, pos)
    pair = ParenMatch.pair_at(code, pos)

    color = pair.correctly_matched? ? Pry.config.coolline_matched_paren :
      Pry.config.coolline_mismatched_paren

    pair.insertion_positions.each do |before, after|
      code.insert after, "\e[0m"
      code.insert before, color
    end
  end
end
