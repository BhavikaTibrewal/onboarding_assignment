require './player'
require './dice'

class GreedGame
  attr_reader :players

  STARTING_SCORE = 300
  ENDING_SCORE = 3000

  def initialize(num_of_players)
    @players =[]
    num_of_players.times {|i| @players << Player.new(i+1)}
    @score_map = { 1 => 1000, 2 => 200, 3 => 300, 4 => 400, 5 => 500, 6 => 600 }
  end

  def calculate_score(dices)
    number_occurence_map = Hash.new{0}
    
    dices.each  {|i|  number_occurence_map[i] += 1}
  
    score = 0
    number_occurence_map.each do |number, count|
        if count >= 3
            number_occurence_map[number] -= 3
            score += @score_map[number]
        end
    end

    if number_occurence_map[1]>=1
        score += (100 * number_occurence_map[1])
        number_occurence_map[1] = 0
    end
    if number_occurence_map[5] >= 1
        score += (50 * number_occurence_map[5])
        number_occurence_map[5] = 0
    end

    return score, number_occurence_map.select { |_, value| value.positive? }
  end

  def play_turn(number_of_dices, player, turn_score)
      dices = Dice.roll(number_of_dices)
      puts "Player #{player.player_id} rolls: #{dices}"
      score, non_scoring_dices = calculate_score(dices)
      puts "Score in this round: #{score}"
      turn_score += score
      return 0 if score.zero?
      return turn_score if non_scoring_dices.empty?

      print "Do you want to roll the non-scoring #{non_scoring_dices} dices?(y/n):"

      roll_again = gets.chomp.downcase
      num_non_scoring_dices = 0
      if roll_again == 'y'
        non_scoring_dices.each{|_, count| num_non_scoring_dices += count}
        play_turn(num_non_scoring_dices, player, turn_score)
      else
        return turn_score
      end

  end

  def final_showdown
    @players.any?{|player| player.score > ENDING_SCORE}
  end

  def play_game
    turn = 1
    
    loop do 
        puts "Turn #{turn}"
        @players.each do |player|
          turn_score = play_turn(5, player, 0)
          player.in_game = true if player.score == 0 && turn_score > STARTING_SCORE
          player.score += turn_score if player.in_game
          puts "Total Score: #{player.score}"
        end

        if final_showdown
          puts "A Player has scored #{ENDING_SCORE} points - Final Show down"
          break
        else
          turn += 1
        end
    end

    puts "---------------------"
    @players.each { |player|
      player.score = play_turn(5, player, 0)
    }

    winner = @players.max_by{|player| player.score }
    puts "\n Player #{winner.player_id} wins with #{winner.score} points!"
  end
end
