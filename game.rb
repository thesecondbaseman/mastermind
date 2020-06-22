# frozen_string_literal: true

require_relative 'keypegs'
require_relative 'displaytext'

# for Mastermind Game creation
class Game
  include KeyPegs
  include DisplayText
  attr_accessor :code_maker, :code_breaker, :keypegs, :code_breaker_attempts
  attr_reader :num_of_games, :codepeg_size, :max_tries, :codepeg_colors

  def initialize(code_maker, code_breaker, num_of_games)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @num_of_games = num_of_games
    @codepeg_size = 4
    @max_tries = 12
    @codepeg_colors = %w[r g b o y m]
    @keypegs = {}
    @code_breaker_attempts = {}
  end

  def play_game
    num_of_games.times do
      max_tries.times do |try|
        play_round(code_maker, code_breaker, codepeg_size, try)
        break if winner?(try)
      end
      # swap_players
    end
  end

  private

  def play_round(code_maker, code_breaker, codepeg_size, try)
    puts "Attempt: #{try + 1}"
    @code = code_maker.choose_code(codepeg_colors, codepeg_size) if try.zero?
    code_breaker_guess = code_breaker.guess(codepeg_colors, codepeg_size)
    code_breaker_attempts[try] = code_breaker_guess
    keypegs[try] = get_keypegs(@code, code_breaker_guess)
    puts "Attempt => #{display_hash(code_breaker_attempts)}"
    puts "Keypegs => #{display_hash(keypegs)} \n "
  end

  def winner?(try)
    if keypegs[try].all? { |peg| peg == 'b' } && keypegs[try].length == codepeg_size
      puts "#{code_breaker.name} cracked the code!"
      true
    elsif try == max_tries - 1
      puts "#{code_maker.name}'s code was never cracked!"
      puts 'Code: '
      true
    end
  end

  def swap_players
    temp = code_maker
    self.code_maker = code_breaker
    self.code_breaker = temp
  end
end
