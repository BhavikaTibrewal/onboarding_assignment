class Player
  attr_accessor :score
  attr_accessor :in_game
  attr_reader :player_id

  def initialize(player_id)
    @player_id = player_id
    @score = 0
    @in_game = false
  end
end
