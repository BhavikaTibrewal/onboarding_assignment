# include GreedGame
require_relative "./greed_game.rb"
puts "Enter number of players"
players = gets.to_i

if (players.is_a? Numeric) && (players > 1)
    game = GreedGame.new(players)
    game.play_game
else 
    puts "Please enter a valid num of players"
end

