require './greed_game'
require './player'
require './dice'

RSpec.describe GreedGame do
  let(:game) { GreedGame.new(2) }

  describe '#initialize' do
    it 'creates the correct number of players' do
      expect(game.players.length).to eq(2)
    end

    it 'initializes players with the correct ids' do
      player1 = game.players.first
      player2 = game.players.last
      expect(game.players.map(&:player_id)).to eq([1, 2])
      expect(player1.score).to eq(0)
      expect(player1.in_game).to be_falsey
      expect(player2.score).to eq(0)
      expect(player2.in_game).to be_falsey
    end
  end

  describe '#calculate_score' do
    it 'returns correct score for various dice rolls' do
      expect(game.calculate_score([])).to eq([0, {}])
      expect(game.calculate_score([1])).to eq([100, {}])
      expect(game.calculate_score([1, 1, 1, 5, 5])).to eq([1100, {}])
      expect(game.calculate_score([2, 3, 4, 6, 2])).to eq([0, {2=>2, 3=>1, 4=>1, 6=>1}])
      expect(game.calculate_score([1, 2, 3, 4, 5])).to eq([150, {2=>1, 3=>1, 4=>1}])
    end
  end

  describe '#play_turn' do
    before do
      expect(Dice).to receive(:roll).and_return([4, 5, 3, 3, 4], [1, 3, 4, 2], [5, 6, 6])
      expect(game).to receive(:gets).and_return('y', 'y', 'n')
    end

    it 'calculates the score for a turn' do
      player1 = game.players.first
      expect(game.play_turn(5, player1, 0)).to eq(200)
    end
  end

  describe '#final_showdown' do
    it 'returns true if any player has a score greater than ENDING_SCORE' do
      game.players.first.score = 3100
      expect(game.final_showdown).to be true
    end

    it 'returns false if no player has a score greater than ENDING_SCORE' do
      expect(game.final_showdown).to be false
    end
  end

  describe '#play_game' do
    before do
      allow(game).to receive(:play_turn).and_return(350, 100, 400, 0, 100, 150, 250)
    end

    it 'declares the player with the highest score as the winner' do
      game.play_game

      winner = game.instance_variable_get(:@players).max_by { |player| player.score }
      expect(winner.player_id).to eq(1)
    end

  end
end
