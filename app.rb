require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    validity_of_guess = @game.guess(letter)
    begin
      if !validity_of_guess
        flash[:message] = "You have already used that letter."
      end
    rescue
      if letter != /[A-Za-z]/ 
        flash[:message] = "Invalid guess."
      end
    end
    redirect '/show'
    
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    case @game.check_win_or_lose 
    when :win  
      redirect '/win'
    when :lose
      redirect '/lose'
    when :play  
      erb :show
    end
  end
  
  get '/win' do
    #check if really won!
    if @game.check_win_or_lose == :win
      erb :win # You may change/remove this line
    else 
      flash[:message] = "Try to actually guess the word without cheating."
      redirect '/show'
    end
    
  end
  
  get '/lose' do
    if @game.check_win_or_lose == :lose
      erb :lose # You may change/remove this line
    else 
      flash[:message] = "You didn't really lose."
      redirect '/show'
    end
  end
  
end
