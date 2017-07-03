# https://stormy-plains-31979.herokuapp.com
class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses=''
    @wrong_guesses=''
  end
  
  attr_accessor :word,:guesses, :wrong_guesses

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  def guess my_guess
    if my_guess == nil
      raise ArgumentError.new("invalid guess")
    end
    if my_guess.length != 1
      raise ArgumentError.new("invalid guess")
    end
    if !(my_guess =~ /[A-Za-z]/)
      raise ArgumentError.new("invalid guess")
    end  
    word_check = @word.downcase
    guess_check = my_guess.downcase
    if !(@guesses.include? guess_check)&& !(@wrong_guesses.include? guess_check)
      if word_check.include? guess_check
        @guesses += guess_check
      else
        @wrong_guesses += guess_check
      end
      return true
    else
      return false    
    end
  end
  
  def word_with_guesses
    display=''
    @word.chars do |char|
      if @guesses.include? char.downcase
        display += char
      else
        display += '-'
      end
    end
    return display
  end
  
  def check_win_or_lose
    if self.word_with_guesses.eql? @word
      return :win
    elsif @wrong_guesses.length >=7
      return :lose
    else
      return :play
    end
  end

end



