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
      expect(game.players.map(&:player_id)).to eq([1, 2])
    end
  end

  describe '#calculate_score' do
    it 'returns correct score for various dice rolls' do
      expect(game.calculate_score([1, 1, 1, 5, 5])).to eq([1100, {}])
      expect(game.calculate_score([2, 3, 4, 6, 2])).to eq([0, {2=>2, 3=>1, 4=>1, 6=>1}])
      expect(game.calculate_score([1, 2, 3, 4, 5])).to eq([150, {2=>1, 3=>1, 4=>1}])
    end
  end

  describe '#play_turn' do
    before do
      allow(Dice).to receive(:roll).and_return([1, 1, 1, 5, 5])
      allow(game).to receive(:gets).and_return('n')
    end

    it 'calculates the score for a turn' do
      player = game.players.first
      expect(game.play_turn(5, player, 0)).to eq(1100)
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
    it 'runs a full game and declares a winner' do
      allow(Dice).to receive(:roll).and_return([1, 1, 1, 5, 5])
      allow(game).to receive(:gets).and_return('n')
      expect { game.play_game }.to output(/Player \d wins with \d+ points!/).to_stdout
    end
  end
end
