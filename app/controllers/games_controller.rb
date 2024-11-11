require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].downcase
    @attempt = params[:response].downcase.strip

    if !valid_word?(@attempt, @letters)
      @score = 0
      @message = 'The word must be built from the grid.'
    elsif !fetch_word_data(@attempt)
      @score = 0
      @message = 'The word is not a valid English word.'
    else
      score = @attempt.size * 10
      @score = score
      @message = "Well done! You got #{score} points"
    end
  end

  private

  def valid_word?(guess, letters)
    guess.chars.all? do |letter|
      letters.include?(letter) && letters.count(letter) >= guess.chars.count(letter)
    end
  end

  def fetch_word_data(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    response = URI.parse(url).read
    result = JSON.parse(response)
    result['found']
  end
end
