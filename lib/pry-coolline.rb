# pry-coolline.rb
# (C) John Mair (banisterfiend); MIT license

require 'pry'

unless defined?(Pry.config.coolline_paren_matching)
  Pry.config.coolline_paren_matching = true
end

Pry.config.coolline_matched_paren    ||= "\e[42m"
Pry.config.coolline_mismatched_paren ||= "\e[41m"

begin
  require 'coolline'

  require 'pry-coolline/paren_match'
  require 'pry-coolline/wrapper'

  Pry.config.input = PryCoolline.make_input

  require 'pry-bond'

  if Pry::BondCompleter.respond_to?(:start)
    Pry::BondCompleter.start
  elsif Pry::BondCompleter.respond_to?(:setup)
    Pry::BondCompleter.setup
  end
  # Fixes a bug with certain gem releases of pry
  Pry.config.completer = Pry::BondCompleter

  # Let's speak in Bond's metaphor.
  # Assasinate the agent and replace it with one that uses our weapon.
  Bond::M.reset
  Bond.start :readline => Pry.config.input.bond_adapter
rescue LoadError
end if ENV["TERM"] != "dumb"
