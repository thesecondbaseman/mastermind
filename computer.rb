# frozen_string_literal: true

# Computer class
class Computer
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def choose_code(available_codes, codepeg_size)
    range = available_codes.length
    selected_codes = []
    codepeg_size.times { selected_codes << available_codes[rand(range)] }
    selected_codes
  end
end
