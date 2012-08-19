# -*- coding: utf-8 -*-
require File.expand_path("helpers.rb", File.dirname(__FILE__))

# This code allows to test paren matching against:
#   - multibyte characters;
#   - ANSI codes.
code = <<eof
)foo (bar) bat} [béz] () bat] ( 3} [bat {bar}\e[3m] [
eof

PM = PryCoolline::ParenMatch

context PM do
  setup { PM }

  def pair(a = nil, b = nil)
    PM::Pair.new(a ? PM::OpenToken.new(*a) : a,
                 b ? PM::CloseToken.new(*b) : b)
  end

  asserts(:pair_at, code, 0).equals pair
  asserts(:pair_at, code, 1).equals pair(nil, [")", 0, 0])
  asserts(:pair_at, code, 3).equals pair
  asserts(:pair_at, code, 5).equals pair(["(", 5, 5], [")", 9, 9])
  asserts(:pair_at, code, 15).equals pair(nil, ["}", 14, 14])
  asserts(:pair_at, code, 22).equals pair(["(", 22, 22], [")", 23, 23])
  asserts(:pair_at, code, 23).equals pair
  asserts(:pair_at, code, 24).equals pair(["(", 22, 22], [")", 23, 23])
  asserts(:pair_at, code, 30).equals pair(["(", 30, 30], ["}", 33, 33])
  asserts(:pair_at, code, 34).equals pair(["(", 30, 30], ["}", 33, 33])
  asserts(:pair_at, code, 35).equals pair(["[", 35, 35], ["]", 45, 49])
  asserts(:pair_at, code, 40).equals pair(["{", 40, 40], ["}", 44, 44])
  asserts(:pair_at, code, 45).equals pair(["{", 40, 40], ["}", 44, 44])
  asserts(:pair_at, code, 46).equals pair(["[", 35, 35], ["]", 45, 49])
  asserts(:pair_at, code, 47).equals pair(["[", 47, 51])
end

context "a fully matched pair" do
  setup do
    PM::Pair.new(PM::OpenToken.new("abc", 3, 4),
                 PM::CloseToken.new("ab", 10, 15))
  end

  denies(:correctly_matched?)
  denies(:correctly_matched?, "abc" => "cba")
  asserts "correctly matched if pairs are right" do
    topic.correctly_matched? "abc" => "ab"
  end

  asserts(:insertion_positions).equals [[15, 17], [4, 7]]
end

context "a pair without closing token" do
  setup do
    PM::Pair.new(PM::OpenToken.new("abc", 3, 4))
  end

  denies(:correctly_matched?)
  asserts(:insertion_positions).equals [[4, 7]]
end

context "a pair without opening token" do
  setup do
    PM::Pair.new(nil, PM::CloseToken.new("ab", 10, 15))
  end

  denies(:correctly_matched?)
  asserts(:insertion_positions).equals [[15, 17]]
end

context "an empty pair" do
  setup { PryCoolline::ParenMatch::Pair.new }

  denies(:correctly_matched?)
  asserts(:insertion_positions).empty
end
