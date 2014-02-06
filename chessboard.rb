require "colorize"
require "debugger"

class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) {nil} }
    setup_pieces
  end

  def d_dup
    duped_grid = []
    self.grid.each do |row|

      duped_row = row.map do |square|
        square.dup unless square.nil?
      end
      duped_grid << duped_row
    end
    d = Board.new
    d.grid = duped_grid
    d
  end

  def move_into_check?(start_pos, end_pos, team)
    duped_board = self.d_dup
    duped_board.dup_move(start_pos, end_pos, team)
    if duped_board.in_check?(team)
      return true
    end
    false
  end

  def dup_move(start_pos, end_pos, team)
    piece_to_move = self[start_pos]
    if piece_to_move.moves.include?(end_pos)
      self[end_pos] = piece_to_move
      self[start_pos] = nil
      piece_to_move.position = end_pos[0], end_pos[1]
    else
      raise "Invalid move."
    end
    false
  end

  def [](coordinates)
    x, y = coordinates
    @grid[x][y]
  end

  def []=(coordinates, item)
    x, y = coordinates
    @grid[x][y] = item
  end

  def setup_pieces
    place_piece([0,0], 'rook', 'red')
    place_piece([0,7], 'rook', 'red')
    place_piece([7,0], 'rook', 'blue')
    place_piece([7,7], 'rook', 'blue')
    place_piece([0,6], 'knight', 'red')
    place_piece([0,1], 'knight', 'red')
    place_piece([7,1], 'knight', 'blue')
    place_piece([7,6], 'knight', 'blue')
    place_piece([0,2], 'bishop', 'red')
    place_piece([0,5], 'bishop', 'red')
    place_piece([7,2], 'bishop', 'blue')
    place_piece([7,5], 'bishop', 'blue')
    place_piece([0,3], 'king', 'red')
    place_piece([7,3], 'king', 'blue')
    place_piece([0,4], 'queen', 'red')
    place_piece([7,4], 'queen', 'blue')
    8.times{ |y| place_piece([1,y], 'pawn', 'red') }
    8.times{ |y| place_piece([6,y], 'pawn', 'blue') }
  end


  def move_piece( start_pos, end_pos, team )
    if self[start_pos].nil?
      raise ArgumentError.new "You tried to move an empty square!"
    end
    if move_into_check?( start_pos, end_pos, self[start_pos].team )
      raise ArgumentError.new "I can't let you do that, Dave."
    end
    piece_to_move = self[start_pos]
    if piece_to_move.moves.include?(end_pos)
      self[end_pos] = piece_to_move
      self[start_pos] = nil
      piece_to_move.position = end_pos[0], end_pos[1]
    else
      raise ArgumentError.new "That doesn't seem like a good idea."
    end
  end

  def place_piece(position, sigil, team)
    case sigil
    when 'rook'
      piece = Rook.new(position, self, team)
    when 'knight'
      piece = Knight.new(position, self, team)
    when 'bishop'
      piece = Bishop.new(position, self, team)
    when 'queen'
      piece = Queen.new(position, self, team)
    when 'pawn'
      piece = Pawn.new(position, self, team)
    when 'king'
      piece = King.new(position, self, team)
    end

    self[position]= piece
  end

  def render
    display = @grid.map do |row|
      row.map do |square|
        if square.nil?
          square = '  '
        else
          square.sigil
        end
      end
    end

    display.each_with_index do |row, ind|
      row.map!.with_index do
        |x,i| if ind.odd? && i.odd?
          x.colorize(:background => :white)
        elsif ind.even? && i.even?
          x.colorize(:background => :white)
        else
          x
        end
      end
    end

    display.map!{|row|  row.join('') }
    display.each_with_index{|row, ind| puts "#{ind} #{row}"}
    puts "  a b c d e f g h"
  end

  def find_king(color)

    self.grid.each_with_index do |row, row_index|
      row.each do |item|
        if item.class == King && item.team == color
          # uts "Row and column of #{color} king: #{item.position}"
          return item.position
        end
      end
    end

  end

  def in_check?(color)
    @grid.each do |row|
      row.each do |square|
        unless square.nil?
           if square.moves.include?(find_king(color))
             # if square.class == Pawn
#                copy = square.moves.dup
#                copy.delete_if{|x| x[1] == square.position[1]}
#                return true if copy.include?(find_king(color))
#              else
               return true

           end
        end
      end
    end
    false
  end

  def checkmate?(color)
    # debugger
    moves_left = 0
    @grid.each do |row|
      row.each do |square|
        next if square.nil?
        next if square.team != color
        square.moves.each do |move|
          next if !move || move.empty?
          unless move_into_check?(square.position, move, color)
            moves_left += 1
          end
        end
      end
    end
    # debugger
    moves_left == 0 ? true : false
  end

end

