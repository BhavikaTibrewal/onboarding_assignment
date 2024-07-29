class Dice
  def self.roll(number_of_dices)
    number_of_dices.times.map { rand(1..6) }
  end
end
