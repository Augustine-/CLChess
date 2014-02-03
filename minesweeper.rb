class Board
  attr_reader :board
  def initialize(size, bombs)
    @size = size
    @bombs = bombs
    @board = []
    spawn(size[1])
  end

  def spawn(num_rows)
    num_rows.times do |row|
      @board << Array.new(@size[0]) { Tile.new("B") }
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

b = Board.new([2, 3], 0)


puts b.board.to_s
