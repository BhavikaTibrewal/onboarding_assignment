class Player
  attr_accessor :score
  attr_reader :player_id

  def initialize(player_id)
    @player_id = player_id
    @score = 0
  end

  def add_score(points)
    @score += points
  end
end