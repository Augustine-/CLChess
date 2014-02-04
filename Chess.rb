NORTH = [0, 1]
SOUTH = [0 , -1]
EAST = [1 , 0]
WEST = [-1 , 0]
NORTHEAST = [1 , 1]
SOUTHEAST = [1 , -1]
NORTHWEST = [-1, 1]
SOUTHWEST = [-1, -1]

class Piece
  attr_accessor :position, :sigil
  def initialize(coords)
    @position = coords[0], coords[1]
  end

  def moves
    piece.move_dirs.select { |dir| dir >= 0 && dir < 8 }
  end
end

class SlidingPiece < Piece
  def moves
  end
end

class SteppingPiece < Piece
end

class Bishop < SlidingPiece
  attr_accessor :sigil


  def moves
    moves = []
    x = self.position[0]
    y = self.position[1]
    #...diagonals...
  end

end

class Rook < SlidingPiece
  attr_accessor :sigil

  def initialize
    @sigil = "R"
  end

  def move_dirs
  end

  def moves
    moves = []
    x = self.position[0]
    y = self.position[1]
    8.times do |t|
      moves << [t,y] << [t,x]
    end
  end


end

class Queen < SlidingPiece
end


class Pawn
end









class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) {nil} }
  end

  def [](coordinates)
    x, y = coordinates
    @grid[x][y]
  end

  def setup_pieces
  end

  def place_piece(position)
    piece = Rook.new
    @grid[position[0]][position[1]] = piece
    piece.position = position
  end

  def show
    pp grid
  end

  def render

    display = @grid.map do |row|
      row.map do |square|
        if square.nil?
          square = ' '
        else
          square.sigil
        end
      end
    end
    display
  end

end







class Player
end

b = Board.new

