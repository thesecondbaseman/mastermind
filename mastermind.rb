# frozen_string_literal: true

require_relative 'game'
require_relative 'computer'
require_relative 'user'

num_of_games = nil
loop do
  print 'Enter even number of games: '
  num_of_games = gets.chomp.to_i
  break if num_of_games.even? && num_of_games.positive?
end

code_maker = Computer.new('Computer')
code_breaker = User.new('Chris')
mastermind = Game.new(code_maker, code_breaker, num_of_games)
mastermind.play_game
