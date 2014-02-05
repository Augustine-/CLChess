require "./chessboard.rb"
require "debugger"

NORTH            = [0, 1]
SOUTH            = [0 , -1]
EAST             = [1 , 0]
WEST             = [-1 , 0]
NORTHEAST        = [1 , 1]
SOUTHEAST        = [1 , -1]
NORTHWEST        = [-1, 1]
SOUTHWEST        = [-1, -1]


class Array
  def merge_sum
    self.transpose.map {|x| x.reduce(:+)}
  end
end


class Piece
  attr_accessor :position, :sigil, :grid

  def initialize(coords, board)
    @position    = coords[0], coords[1]
    @board        = board
  end

  #called by Board::move_piece
  #calls cardinal_directions
  def moves

  end


end

class SlidingPiece < Piece

  #called by cardinal_directions
  #calls
  def legal_moves(direction)
    cards = []
    origin = @position

    7.times do
      checking_position = [origin, direction].merge_sum
      break if checking_position.any? {|x| x >7 || x < 0}
      break unless @board[checking_position].nil?
      cards << [origin, direction].merge_sum
      origin = [origin, direction].merge_sum
    end
    cards
  end


  #called by 'moves
#calls 'legal_moves'
def cardinal_directions
  legal_moves(NORTH) +
  legal_moves(EAST) +
  legal_moves(SOUTH) +
  legal_moves(WEST)
end

def diagonal_directions
  legal_moves(NORTHWEST) +
  legal_moves(NORTHEAST) +
  legal_moves(SOUTHWEST) +
  legal_moves(SOUTHEAST)
end



end




class Bishop < SlidingPiece

  def moves
    diagonal_directions
  end

end

class Rook < SlidingPiece
  attr_accessor :sigil

  def initialize(position, board)
    @position    = position
    @board       = board
    @sigil       = "R"
  end

  def moves
    cardinal_directions
  end


end



b = Board.new

b.place_piece([2,2],'rook')
pp b.render

b.move_piece([2, 2], [2, 4])
pp b.render

# b.place_piece([1, 0],'rook')
# pp "before move"
# pp b.render
# b.move_piece([1,0], [1,5])
# pp "after move"
# pp b.render

