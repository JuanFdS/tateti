
class Play

  attr_accessor :symbol, :position

  def initialize(symbol, position)
    @symbol = symbol
    @position = position
  end

  def hash
    [@symbol, @position].hash
  end

  def ==(other_play)
    symbol == other_play.symbol && position == other_play.position
  end

end