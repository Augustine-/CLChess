require "./chessboard.rb"
require "colorize"
require "debugger"

EAST           = [0, 1]
WEST            = [0 , -1]
NORTH             = [-1 , 0]
SOUTH            = [1 , 0]
NORTHEAST        = [-1 , 1]
SOUTHEAST        = [-1 , -1]
NORTHWEST        = [1 , 1]
SOUTHWEST        = [1 , -1]

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


  #sliding_piece overrides this method for special version for sliding pieces
  def legal_moves(end_position)
    if end_position.all? { |x| x < 8 && x > -1 }
      if @board[end_position].nil?
        return end_position
      elsif @board[end_position].team != self.team
        return end_position
      end
    end
  end
end

class SteppingPiece <Piece

end

class SlidingPiece < Piece

  #called by cardinal_directions
  #calls
  def legal_moves(direction)
    moves = []
    origin = @position

    7.times do
      checking_position = [origin, direction].merge_sum
      break if checking_position.any? {|x| x >7 || x < 0}
      if @board[checking_position].nil?
        moves << [origin, direction].merge_sum
        origin = [origin, direction].merge_sum
      elsif
        @board[checking_position].team != self.team
        moves << [origin, direction].merge_sum
        moves
        break
      end
      end
      moves
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
   @sigil = team == "red" ? "\u{265D} ".colorize(:red) : "\u{265D} ".colorize(:blue)
  end

  def moves
    diagonal_directions
  end

end

class Rook < SlidingPiece
  attr_accessor :sigil

  def initialize(position, board, team)
    super
    @sigil = team == "red" ?  "\u{265C} ".colorize(:red) : "\u{265C} ".colorize(:blue)
  end

  def moves
    cardinal_directions
  end
end

class Queen < SlidingPiece
  attr_accessor :sigil

  def initialize(position, board, team)
    super
    @sigil = team == "red" ?  "\u{265B} ".colorize(:red) : "\u{265B} ".colorize(:blue)
  end

  def moves
    moves = []
    moves << diagonal_directions
    moves << cardinal_directions
    moves = moves.flatten(1)

    moves
  end
end

class Knight < SteppingPiece
  attr_accessor :sigil

  DELTAS = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

  def initialize(position, board, team)
    super
    @sigil = team == "red" ?  "\u{265E} ".colorize(:red) : "\u{265E} ".colorize(:blue)
  end

  def moves
    good_spots = []

    start = @position.dup
    DELTAS.each do |delta|
      start[0] += delta[0]
      start[1] += delta[1]
      good_spots << legal_moves(start)
      start = @position.dup
    end
    good_spots.compact!
    good_spots
  end
end

class King < SteppingPiece
  attr_accessor :sigil

  KDELTS = [[-1, -1],[-1, 1],[1, -1],[1, 1],[-1, 0],[1, 0],[0, -1],[0, 1]]


  def initialize(position, board, team)
    super
    @sigil = team == "red" ?  "\u{265A} ".colorize(:red) : "\u{265A} ".colorize(:blue)
  end

  def moves
      good_spots = []

      start = @position.dup
      KDELTS.each do |delta|
        start[0] += delta[0]
        start[1] += delta[1]
        good_spots << legal_moves(start)
        start = @position.dup
      end
      good_spots.select {|x| x != []}
  end

end

class Pawn < Piece
  def initialize(position, board, team)
    super
    @start_position = position
    @sigil = if team == "red"
     "\u{265F} ".colorize(:red)
   else
     "\u{265F} ".colorize(:blue)
   end
  end

  def moves
    output = []
    pos = @position.dup
    if team == 'blue'
      output =  add_steps(NORTH)
      output << check_enemies(NORTHEAST)
      output << check_enemies(NORTHWEST)
    else
      output = add_steps(SOUTH)
      output << check_enemies(SOUTHEAST)
      output << check_enemies(SOUTHWEST)
    end
  end

  def check_enemies(direction)
    output =[]
    pos = self.position.dup
    pos[0] += direction[0]
    pos[1] += direction[1]
    if pos.all? do |x|
       x < 8 && x > -1
     end && @board[pos] != nil && @board[pos].team != self.team
      output << pos
    end
    output.flatten
  end

  def add_steps(direction)
    output = []
    pos = @position.dup
    if @start_position == pos
      2.times do
        pos[0] += direction[0]
        output << pos.dup
      end
    else
      pos[0] += direction[0]
      output << pos
    end
    output
  end




end



b = Board.new
start = [7,0]
ends = [0,0]
go = [0,1]
gogo = [0,2]
soclose = [0,3]


    # b.render
    # b.move_piece(start,ends)
    # p b[ends].moves
    # b.move_piece(ends, go)
    # b.render
    # b.move_piece(go, gogo)
    # b.render
    # b.move_piece(gogo, soclose)
    # b.render
    # p b.in_check?("red")
    # b.move_piece(soclose, [0,3])
    # b.render
    # b.move_piece([0,3], [2, 2])
    # b.render

p b.move_piece(start, ends)
b.render
p b.move_piece(ends, go)
b.render
p b.move_piece(go, gogo)
b.render
p b.in_check?("red")

