class Board

  attr_reader :board
  def initialize(rows, columns, bombs)
    @rows = rows
    @columns = columns
    @board = set_board_area
    drop_the_bombs(bombs)
  end

  def set_board_area
    [].tap do |board|
      @columns.times do |row|
        board << Array.new(@rows) { Tile.new }
      end
    end
  end

  def drop_the_bombs(bomb_count)

    bomb_count.times do
      @board.sample.sample.bombed = true
    end
  end


  def to_s
    size.to_s
  end


end

class Tile
  attr_accessor :bombed, :flagged, :revealed
  def initialize
    @bombed = false
    @flagged = false
    @revealed = false
  end



end


class Game
  def initialize

  end
end

b = Board.new(2, 3, 1)


b.board.each do |row|
  row.each do |tile|
    puts tile.bombed
  end
end

