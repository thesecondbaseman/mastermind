# frozen_string_literal: true

# Artificial Intelligence Module for Computer
module ArtificialIntelligence
  def intelligent_guess(codepeg_size, attempts)
    loop do
      b_count = best_guess.last[:b]
      w_count = best_guess.last[:w]
      best_guess = self.best_guess.first
      new_guess = get_b_codepegs(best_guess, b_count, codepeg_size)
      new_guess = get_w_codepegs(best_guess, new_guess, w_count, codepeg_size)
      new_guess = guess_empty_slots(codepeg_size, new_guess)
      return new_guess if okay?(new_guess, attempts, best_guess, b_count, w_count)
    end
  end

  def get_w_codepegs(best_guess, new_guess, w_count, codepeg_size)
    available_indexes = get_available_indexes(new_guess, codepeg_size)
    new_indexes = available_indexes.clone
    w_count.times do
      index = available_indexes.sample
      new_index = (new_indexes - [index]).sample
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

  def okay?(new_guess, attempts, best_guess, b_count, w_count)
    return false unless no_dupe?(new_guess, attempts)
    return false unless same_b_count?(best_guess, b_count, new_guess)
    return false unless same_w_count?(best_guess, w_count, new_guess)

    true
  end

  def same_w_count?(best_guess, w_count, new_guess)
    w_indexes = []
    banned_indexes = []
    new_guess.each_with_index do |codepeg, index|
      banned_indexes << index and next if best_guess[index] == codepeg

      get_possible_swaps(best_guess, banned_indexes, w_indexes, index).each do |swap_index|
        w_indexes << swap_index if codepeg == best_guess[swap_index]
      end
    end
    w_indexes.uniq.length == w_count || w_count.zero?
  end

  def get_possible_swaps(best_guess, banned_indexes, w_indexes, index)
    (0...best_guess.length).to_a - banned_indexes - w_indexes - [index]
  end

  def same_b_count?(best_guess, b_count, new_guess)
    best_guess.each_index { |i| b_count -= 1 if best_guess[i] == new_guess[i] }
    true if b_count.zero?
  end

  def no_dupe?(guess, attempts)
    attempts = attempts.values
    !attempts.include?(guess)
  end

  def get_b_codepegs(best_guess, b_count, codepeg_size)
    new_guess = []
    indexes = (0...codepeg_size).to_a.shuffle
    until b_count.zero?
      index = indexes.pop
      if available?(index, best_guess[index])
        new_guess[index] = best_guess[index]
        b_count -= 1
      end
    end
    new_guess
  end

  def available?(index, codepeg)
    possible_codes[index].include?(codepeg)
  end

  def guess_empty_slots(codepeg_size, new_guess = [])
    codepeg_size.times do |i|
      new_guess[i] = possible_codes[i].sample unless new_guess[i]
    end
    new_guess
  end
end
