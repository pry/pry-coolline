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
  require 'pry-coolline/wrapper'

  Pry.config.input = PryCoolline.make_input

  require 'pry-bond'

  Pry::BondCompleter.start
  # Fixes a bug with certain gem releases of pry
  Pry.config.completer = Pry::BondCompleter

  # Let's speak in Bond's metaphor.
  # Assasinate the agent and replace it with one that uses our weapon.
  Bond::M.reset
  Bond.start :readline => Pry.config.input.bond_adapter
rescue LoadError
end if ENV["TERM"] != "dumb"
