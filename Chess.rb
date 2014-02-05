require "./chessboard.rb"
require "colorize"
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
  attr_accessor :position, :sigil, :grid, :team

  def initialize(coords, board, team)
    @position    = coords[0], coords[1]
    @board        = board
    @team = team
  end

end

class SteppingPiece <Piece
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
  def initialize(position, board, team)
    super
   @sigil = team == "white" ? "\u{265D} ".colorize(:red) : "\u{265D} ".colorize(:blue)
  end

  def moves
    diagonal_directions
  end

end

class Rook < SlidingPiece
  attr_accessor :sigil

  def initialize(position, board, team)
    super
    @sigil = team == "white" ?  "\u{265C} ".colorize(:red) : "\u{265C} ".colorize(:blue)
  end

  def moves
    cardinal_directions
  end
end

class Queen < SlidingPiece
  attr_accessor :sigil

  def initialize(position, board, team)
    super
    @sigil = team == "white" ?  "\u{265B} ".colorize(:red) : "\u{265B} ".colorize(:blue)
  end


end

class Knight < SteppingPiece
  attr_accessor :sigil

  def initialize(position, board, team)
    super
    @sigil = team == "white" ?  "\u{265E} ".colorize(:red) : "\u{265E} ".colorize(:blue)
  end
end

class King < SteppingPiece
  attr_accessor :sigil

  def initialize(position, board, team)
    super
    @sigil = team == "white" ?  "\u{265A} ".colorize(:red) : "\u{265A} ".colorize(:blue)
  end
end





b = Board.new

b.render


