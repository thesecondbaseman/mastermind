# frozen_string_literal: true

require_relative 'keypegs'
require_relative 'displaytext'

# for Mastermind Game creation
class Game
  include KeyPegs
  include DisplayText
  attr_accessor :code_maker, :code_breaker, :keypegs, :code_breaker_attempts
  attr_accessor :code, :game, :try, :score
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
    @game = 1
    @try = 1
  end

  def play_game
    num_of_games.times do
      set_code
      max_tries.times do
        play_round
        display_score and break if winner?

        self.try += 1
      end
      initialize_next_game
    end
    puts declare_winner
  end

  private

  def play_round
    puts "Game: #{game} Try: #{try}"
    code_breaker_guess = guess
    code_breaker_attempts[try] = code_breaker_guess
    keypegs[try] = get_keypegs(code, code_breaker_guess)
    display_results
  end

  def guess
    code_breaker.guess(codepeg_colors, codepeg_size, keypegs, code_breaker_attempts, try)
  end

  def winner?
    if all_b?
      puts "#{code_breaker.name} cracked the code!"
      true
    elsif try == max_tries
      puts "#{code_maker.name}'s code was never cracked!"
      puts "Code: #{code.join}"
      true
    end
  end

  def display_score
    update_score
    names = score.keys
    scores = score.values
    puts "Score: #{names.first}: #{scores.first} | #{names.last}: #{scores.last}"
    puts
    true
  end

  def update_score
    code_maker = self.code_maker.name
    self.score = { code_breaker.name => 0, code_maker => 0 } if score.nil?
    attempts = code_breaker_attempts.length
    attempts += 1 if attempts == max_tries
    score[code_maker] += attempts
  end

  def declare_winner
    names = score.keys
    scores = score.values
    "#{names.first} WINS!" if scores.first > scores.last
    "#{names.last} WINS!" if scores.first < scores.last
    'TIE!'
  end

  def all_b?
    keypegs[try].count('b') == codepeg_size
  end

  def initialize_next_game
    self.game += 1
    self.try = 1
    reset_game
    swap_players
  end

  def swap_players
    temp = code_maker
    self.code_maker = code_breaker
    self.code_breaker = temp
  end

  def reset_game
    code_breaker_attempts.clear
    keypegs.clear
  end

  def set_code
    self.code = code_maker.choose_code(codepeg_colors, codepeg_size)
  end
end
