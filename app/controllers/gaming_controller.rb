require 'open-uri'
require 'json'
require 'uri'

class GamingController < ApplicationController
  def game
    @grid = generate_grid(20)
  end

  def score
    @grid = params[:grid].split("")
    @attempt = params[:attempt]
    @time = params[:time].to_f
    @result = run_game(@attempt, @grid, @time)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    array = []
    grid_size.times do
      chars = ("A".."Z").to_a.sample
      array << chars
    end
    return array
  end

  def run_game(attempt, grid, time)
    # TODO: runs the game and return detailed hash of result
    result = {}
    translation = translate(attempt.downcase)
    result[:translation] = translation
    result[:time] = time
    message, score = game_conditionals(attempt, grid, translation)
    result[:score] = score ? (10_000 / result[:time])  + attempt.length : 0
    result[:translation] = nil if attempt == translation
    result[:message] = message
    return result
  end

  def game_conditionals(attempt, grid, translation)
    score = false
    if !(attempt.upcase.chars.all? { |x| grid.count(x) >= attempt.upcase.count(x) })
      message =  "not in the grid"
    elsif attempt == translation
      message =  "not an english word"
    else
      message =  "well done"
      score = true
    end
    return message, score
  end


  def translate(attempt)
    key = "553b6bb3-8150-4f94-86b1-39325747bbc3"
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{key}&input=#{attempt}"
    translate_api = open(url).read
    translate_parse = JSON.parse(translate_api)
    return translate_parse["outputs"][0]["output"]
  end

end
