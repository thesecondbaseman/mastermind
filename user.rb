# frozen_string_literal: true

# User class for player
class User
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def guess(available_codes, codepeg_size, *_)
    loop do
      puts "Available codes: #{available_codes.join(',')}"
      puts 'Enter code in this example format: ygbo'
      input = gets.chomp.split ''
      next if input.length != codepeg_size
      return input if input.all? { |code| available_codes.include? code }
    end
  end
  
  def choose_code(available_codes, codepeg_size)
    loop do
      print "Enter available codes: #{available_codes.join(',')}: "
      input = gets.chomp.split('')
      next unless valid_chars(input, available_codes)
      return input if input.length == codepeg_size
    end
  end

  def valid_chars(input, available_codes)
    input.each do |char|
      return false unless available_codes.include? char
    end
    true
  end
end
