class Board
  attr_reader :board
  def initialize(size, bombs)
    @size = size
    @bombs = bombs
    spawn
  end

  def spawn
    @board = Array.new(@size[0] * @size[1]) do |tile|
      tile = Tile.new('blank')
    end
  end

  def to_s
    size.to_s
  end


end

class Tile
  attr_reader :type
  def initialize(type)
    @type = type
  end

end


class Game
  def initialize
  end
end

b = Board.new([2, 2], 0)


b.board.each {|i| puts i.type}
