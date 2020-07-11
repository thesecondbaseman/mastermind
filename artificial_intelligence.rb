# frozen_string_literal: true

require_relative 'keypegs'

# Artificial Intelligence Module for Computer
module ArtificialIntelligence
  include KeyPegs
  def intelligent_guess(codepeg_size, attempts)
    loop do
      keypegs = best_guess.last
      best_guess = self.best_guess.first
      new_guess = get_b_codepegs(best_guess, keypegs[:b], codepeg_size)
      new_guess = get_w_codepegs(best_guess, new_guess, keypegs[:w], codepeg_size)
      new_guess = guess_empty_slots(codepeg_size, new_guess)
      return new_guess if okay?(new_guess, attempts, best_guess, keypegs)
    end
  end

  def get_w_codepegs(best_guess, new_guess, w_count, codepeg_size)
    available_indexes = get_available_indexes(new_guess, codepeg_size)
    new_indexes = available_indexes.clone
    w_count.times do
      index = available_indexes.sample
      new_index = (new_indexes - [index]).sample || index
      new_guess[new_index] = best_guess[index]
      available_indexes.delete(index)
      new_indexes.delete(new_index)
    end
    new_guess
  end

  def get_available_indexes(new_guess, codepeg_size)
    indexes = []
    codepeg_size.times { |index| indexes << index if new_guess[index].nil? }
    indexes
  end

  def okay?(new_guess, attempts, best_guess, keypegs)
    true if no_dupe?(new_guess, attempts) && same_keypegs(best_guess, new_guess, keypegs) && available?(new_guess)
  end

  def same_keypegs(best_guess, new_guess, best_guess_keypegs)
    new_guess_keypegs = get_keypegs(best_guess, new_guess)
    new_guess_b_count = new_guess_keypegs.count('b')
    new_guess_w_count = new_guess_keypegs.count('w')
    return true if new_guess_b_count == best_guess_keypegs[:b] && new_guess_w_count == best_guess_keypegs[:w]
  end

  def get_possible_swaps(best_guess, banned_indexes, w_indexes, index)
    (0...best_guess.length).to_a - banned_indexes - w_indexes - [index]
  end

  def no_dupe?(guess, attempts)
    attempts = attempts.values
    !attempts.include?(guess)
  end

  def get_b_codepegs(best_guess, b_count, codepeg_size)
    new_guess = []
    indexes = (0...codepeg_size).to_a.shuffle
    b_count.times do
      index = indexes.pop
      new_guess[index] = best_guess[index]
    end
    new_guess
  end

  def available?(guess)
    guess.each_with_index do |codepeg, index|
      return false unless possible_codes[index].include?(codepeg)
    end
    true
  end

  def guess_empty_slots(codepeg_size, new_guess = [])
    codepeg_size.times do |i|
      new_guess[i] = possible_codes[i].sample unless new_guess[i]
    end
    new_guess
  end
end
