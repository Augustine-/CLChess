

class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) {nil} }
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
    place_piece
  end

  def move_piece( start_pos, end_pos )
    piece_to_move = self[start_pos]
    if piece_to_move.moves(start_pos, end_pos) == true
      self[end_pos]= piece_to_move
      self[start_pos]= nil
    else
      raise "You can't jump over pieces!"
    end
  end


  def place_piece(position, sigil)
    case sigil
    when 'rook'
      piece = Rook.new(position, self)
    when 'knight'
      piece = Knight.new(position, self)
    when 'bishop'
      piece = Bishop.new(position, self)
    when 'queen'
      piece = Queen.new(position, self)
    when 'pawn'
      piece = Pawn.new(position, self)
    when 'king'
      piece = King.new(position, self)
    end

    self[position]= piece
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

