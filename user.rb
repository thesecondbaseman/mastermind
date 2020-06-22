# frozen_string_literal: true

# User class for player
class User
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def guess(available_codes, codepeg_size)
    loop do
      puts "Available codes: #{available_codes}"
      puts 'Enter code in this example format: ygbo'
      input = gets.chomp.split ''
      next if input.length != codepeg_size
      return input if input.all? { |code| available_codes.include? code }
    end
  end
  
  def choose_code(available_codes, codepeg_size)
    selected_codes = []
    loop do
      !selected_codes.empty? and puts "Your code: #{selected_codes}"
      print "Enter available codes #{available_codes}: "
      input = gets.chomp
      selected_codes << input if available_codes.include? input
      break if selected_codes.length == codepeg_size
    end
    selected_codes
  end
end
