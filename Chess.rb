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

  def moves
    piece.move_dirs.select { |dir| dir >= 0 && dir < 8 }
  end

  def empty_moves(moves)
    good_moves = []
    moves.each do |move|
      if @board[move].nil?
        good_moves << move
      end
    end
    good_moves
  end

end

class SlidingPiece < Piece

  def cardinal_dirs(direction)
    cards = []
    origin = @position
    7.times do
      checking_position = [origin, direction].merge_sum
      break if checking_position.any? {|x| x >7 || x < 0}
      break unless @board[checking_position].nil?

      # else
        cards << [origin, direction].merge_sum
        origin = [origin, direction].merge_sum
    end
    cards.select do |square|
      square[0] < 8 && square[0] > 0 &&
      square[1] < 8 && square[1] > 0
    end

  end

  def move_dirs
    four_ways = []

    four_ways << cardinal_dirs(NORTH) <<
    cardinal_dirs(EAST) <<
    cardinal_dirs(SOUTH) <<
    cardinal_dirs(WEST)


    empty_moves(four_ways.flatten(1))
  end


end




class Rook < SlidingPiece
  attr_accessor :sigil

  def initialize(position, board)
    @position    = position
    @board       = board
    @sigil       = "R"
  end


end



b = Board.new

b.place_piece([6,2],'rook')
b.place_piece([6,5],'rook')
pp b[[6,2]].move_dirs

# b.place_piece([1, 0],'rook')
# pp "before move"
# pp b.render
# b.move_piece([6,0], [1,0])
# pp "after move"
# pp b.render

