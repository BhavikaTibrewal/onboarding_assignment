class GreedGame 
  def initialize(num_of_players)
    @num_of_players = num_of_players
    @score_board = Hash.new { 0 }
    @score_map = { 1 => 1000, 2 => 200, 3 => 300, 4 => 400, 5 => 500, 6 => 600 }
  end

  def roll_dice(number_of_dices)
    number_of_dices.times.map{ Random.new.rand(1..6) }
  end

  def calculate_score(dices)
    number_occurence_map = Hash.new{0}
    
    dices.each  {|i|  number_occurence_map[i] += 1}
  
    score = 0
    number_occurence_map.each do |number, count|
        if count >= 3
            number_occurence_map[number] = number_occurence_map[number] - 3
            score += @score_map[number]
        end
    end

    if number_occurence_map[1]>=1
        score = score + (100 * number_occurence_map[1])
        number_occurence_map[1] = 0
    end
    if number_occurence_map[5] >= 1
        score = score + (50 * number_occurence_map[5])
        number_occurence_map[5] = 0
    end

    return score, number_occurence_map.select { |_, value| value.positive? }
  end

  def play_turn(number_of_dices, current_player, turn_score)

      dices = roll_dice(number_of_dices)
      puts "Player #{current_player} rolls: #{dices}"

      score, non_scoring_dices = calculate_score(dices)

      puts "Score in this round: #{score}"

      turn_score += score

      if score.zero?
        return 0
      end

      if  non_scoring_dices.empty?
       return turn_score
      end

      print "Do you want to roll the non-scoring #{non_scoring_dices} dices?(y/n):"

      roll_again = gets.chomp.downcase

      num_non_scoring_dices = 0
      if roll_again == 'y'
        non_scoring_dices.each{|_, count| num_non_scoring_dices += count}
        play_turn(num_non_scoring_dices, current_player, turn_score)
      else
        return turn_score
      end

  end

  def play_game

    turn = 1
    
    loop do 
        puts "Turn #{turn}"
        current_player = 1

        while current_player <= @num_of_players

          turn_score = play_turn(5, current_player, 0)


          # If totol score has increased don't check score>300
          if (@score_board[current_player] === 0) && (turn_score >= 300)
            @score_board[current_player] += turn_score
          elsif @score_board[current_player] > 0
            @score_board[current_player] += turn_score
          end

          puts "Total Score: #{@score_board[current_player]}"
          current_player += 1
        end

        winning_player = @score_board.select{|_, score| score > 500}
        if winning_player.length >0
            puts "A Player has scored 3000 points - Final Show down"
          break
        else

          turn += 1
        end
    end

    current_player = 1
    while current_player <= @num_of_players
      @score_board[current_player] = play_turn(5, current_player, 0)
      current_player += 1
    end

    winner = @score_board.max_by{|_, score| score }
    puts "\n Player #{winner} wins with #{@score_board[winner]} points!"
  end
end