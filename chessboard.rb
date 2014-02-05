require "colorize"

class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) {nil} }
    setup_pieces
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
    place_piece([0,0], 'rook', 'white')
    place_piece([0,7], 'rook', 'white')
    place_piece([7,0], 'rook', 'black')
    place_piece([7,7], 'rook', 'black')
    # place_piece([0,6], 'knight', 'white')
#     place_piece([0,1], 'knight', 'white')
#     place_piece([7,1], 'knight', 'black')
#     place_piece([7,6], 'knight', 'black')
    place_piece([0,2], 'bishop', 'white')
    place_piece([0,5], 'bishop', 'white')
    place_piece([7,2], 'bishop', 'black')
    place_piece([7,5],'bishop', 'black')
    # place_piece([0,3],'king','white')
#     place_piece([7,3], 'king','black')
    place_piece([0,4], 'queen', 'white')
    place_piece([7,4],'queen','black')
  end

  #calls 'moves' on piece
  def move_piece( start_pos, end_pos )
    piece_to_move = self[start_pos]
    if piece_to_move.moves.include?(end_pos)
      self[end_pos]= piece_to_move
      self[start_pos]= nil
    else
      raise "Another piece is in the way"
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
    display.each{|row| puts row}
  end

end

