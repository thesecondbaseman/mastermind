# frozen_string_literal: true

# Keypegs for Mastermind
module KeyPegs
  def get_keypegs(code, guess)
    correct_col_count = get_correct_col_count(code, guess)
    correct_pos_col_count = get_correct_pos_cols(code, guess)
    correct_col_count -= correct_pos_col_count
    keypegs = []
    correct_pos_col_count.times { keypegs << 'b' }
    correct_col_count.times { keypegs << 'w' }
    keypegs
  end

  def get_correct_col_count(code, guess)
    correct_col = 0
    guessed_val_totals = Hash.new 0
    guess.each { |guess_peg| guessed_val_totals[guess_peg] += 1 }
    code.each do |code_peg|
      if guessed_val_totals[code_peg].positive?
        correct_col += 1
        guessed_val_totals[code_peg] -= 1
      end
    end
    correct_col
  end

  def get_correct_pos_cols(code, guess)
    correct_pos_col_count = 0
    code.each_with_index do |code_peg, code_index|
      correct_pos_col_count += 1 if code_peg == guess[code_index]
    end
    correct_pos_col_count
  end
end
