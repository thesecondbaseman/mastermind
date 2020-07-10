# frozen_string_literal: true

require_relative 'artificial_intelligence'

# Computer class
class Computer
  include ArtificialIntelligence
  attr_accessor :name, :possible_codes, :best_guess

  def initialize(name)
    @name = name
  end

  def choose_code(available_codes, codepeg_size)
    range = available_codes.length
    selected_codes = []
    codepeg_size.times { selected_codes << available_codes[rand(range)] }
    selected_codes
  end

  def guess(codepeg_colors, codepeg_size, keypegs, attempts, try)
    delay
    init_guess_params(codepeg_size, codepeg_colors) if try == 1
    if try > 1
      previous_try = try - 1
      previous_keypeg = keypegs[previous_try]
      update_best_guess(keypegs, attempts, previous_try)
      ban_chars_by_pos(attempts[previous_try]) unless previous_keypeg.include?('b')
      ban_chars_everywhere(attempts[previous_try]) unless previous_keypeg.include?('b') || previous_keypeg.include?('w')
    end
    intelligent_guess(codepeg_size, attempts)
  end

  private

  def init_guess_params(codepeg_size, codepeg_colors)
    init_possible_codes(codepeg_size, codepeg_colors)
    self.best_guess = [[], { b: 0, w: 0 }]
  end

  def init_possible_codes(codepeg_size, codepeg_colors)
    @possible_codes = Array.new(codepeg_size) do
      array = []
      codepeg_colors.each { |value| array << value }
      array
    end
  end

  def delay
    puts
    print 'Thinking'
    3.times { sleep 1 and print '.' }
    sleep 1
    puts
  end

  def update_best_guess(keypegs, attempts, previous_try)
    b_count = keypegs[previous_try].count('b')
    w_count = keypegs[previous_try].count('w')
    counts = { b: b_count, w: w_count }
    self.best_guess = [attempts[previous_try], counts] if better_guess?(counts)
  end

  def better_guess?(current_counts)
    best_count = best_guess.last
    return false if current_counts[:b].zero? && current_counts[:w].zero?
    return true if best_count[:b] < current_counts[:b]
    return true if best_count[:b] == current_counts[:b] && best_count[:w] <= current_counts[:w]
  end

  def ban_chars_by_pos(attempt)
    possible_codes.length.times { |i| possible_codes[i].delete(attempt[i]) }
  end

  def ban_chars_everywhere(attempt)
    possible_codes.length.times { |i| attempt.each { |codepeg| possible_codes[i].delete(codepeg) } }
  end
end
