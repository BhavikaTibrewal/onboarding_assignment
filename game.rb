


def calculateScore(dices)
    number_occurance_map = Hash.new{0}
    score_map = { 1 => 1000, 2 => 200, 3 => 300, 4 => 400, 5 => 500, 6 => 600 }

    dices.each  {|i|  number_occurance_map[i] += 1}
  

    score = 0
    number_occurance_map.each do |number, count|
        if count>=3
            number_occurance_map[number] = number_occurance_map[number] - 3
            score = score + score_map[number]
        end
    end

    if number_occurance_map[1]>=1 
        score = score + (100 * number_occurance_map[1])
        number_occurance_map[1] = 0
    end
    if number_occurance_map[5]>=1 
        score = score + (50 * number_occurance_map[5])
        number_occurance_map[5] = 0
    end

    return score, number_occurance_map.select { |_, value| value.positive? }
end

def playGame(players)

    turn = 1
    total_score = Hash.new { 0 }

    loop do 
        puts "Turn #{turn}"
        current_player = 1
        
        while current_player <= players 
            turn_score = 0
            number_of_dices = 5

            loop do
                dices = rollDice(number_of_dices)
                puts "current_player #{current_player} rolls: #{dices}" 

                score, non_scoring_dices = calculateScore(dices)

                puts "Score in this round: #{score}"

                turn_score += score

                # If totol score has increased don't check score>300
                if (total_score[current_player] === 0) && (turn_score >= 300)
                    total_score[current_player] += turn_score
                elsif total_score[current_player] > 0
                    total_score[current_player] += score
                end

                if score.zero? 
                    total_score[current_player] -= turn_score
                    break
                end
                puts "Total Score: #{total_score[current_player]}"

                break if  non_scoring_dices.empty?
                
                print "Do you want to roll the non-scoring #{non_scoring_dices} dices?(y/n):"

                roll_again = gets.chomp.downcase

                num_non_scoring_dices = 0
                if roll_again == 'y'
                    non_scoring_dices.each{|_, count| num_non_scoring_dices += count}
                    number_of_dices = num_non_scoring_dices
                else
                    break
                end
            end
            current_player += 1
            
        end

        winning_player = total_score.select{|_, score| score > 3000}
        if winning_player.length >0
            puts "Player #{winning_player.player} has scored 3000 points - Final Show down"
          break
        else 
          turn += 1
        end
    end
end

puts "Enter number of players"
players = gets.to_i

if players.is_a? Numeric
    playGame(players)
else 
    puts "Please enter a valid num of players"
end