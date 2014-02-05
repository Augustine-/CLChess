require "colorize"

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
    p "dddup"
    d.render
    d
  end

  def move_into_check(start_pos, end_pos, team)
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
    # 8.times{ |y| place_piece([1,y], 'pawn', 'red') }
 #    8.times{ |y| place_piece([6,y], 'pawn', 'blue') }
  end

  #calls 'moves' on piece
  def move_piece( start_pos, end_pos, team )
    raise "no piece there" if self[start_pos].nil?
    if move_into_check( start_pos, end_pos, self[start_pos].team )
      raise "cant move into check"
    end
    piece_to_move = self[start_pos]
    if piece_to_move.moves.include?(end_pos)
      # if self[end_pos].team != self.team
      #
      self[end_pos] = piece_to_move
      self[start_pos] = nil

      piece_to_move.position = end_pos[0], end_pos[1]
    else
      raise "Invalid move."
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
    puts "X"
    display.map!{|row|  row.join('') }

    display.each_with_index{|row, ind| puts "#{ind} #{row}"}
    puts "  0 1 2 3 4 5 6 7 <= Y"
  end

  def find_king(color)

    self.grid.each_with_index do |row, row_index|
      row.each do |item|
        if item.class == King && item.team == color
          #puts "Row and column of #{color} king: #{item.position}"
          return item.position
        end
      end
    end

  end

  def in_check?(color)
    @grid.each do |row|
      row.each do |square|
        unless square.nil?
          return true if square.moves.include?(find_king(color))
        end
      end
    end
    false
  end


end

class Game
end