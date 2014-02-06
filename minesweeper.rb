require 'debugger'

class Board
  attr_reader :board

  def initialize(rows, columns, bombs)
    @rows = rows
    @columns = columns
    @board = set_board_area
    drop_the_bombs(bombs)
    # number_the_tiles
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def set_board_area
    board = Array.new(@rows) { Array.new(@columns) }
    @columns.times do |col|
      @rows.times do |row|
        board[row][col] = Tile.new(self, [row, col])
      end
    end
    board
  end

  #populate the board with bombs
  def drop_the_bombs(bomb_count)
    bomb_count.times do
      @board.sample.sample.bombed = true
    end
  end

  #Sets the near bomb value for all tiles
  # def number_the_tiles
 #    @board.each_with_index do |row, row_idx|
 #      row.each_with_index do |tile, tile_idx|
 #        all_neighbors =  check_neighbors([row_idx, tile_idx])
 #        puts all_neighbors
 #        tile.near_bombs = bombed_neighbors(all_neighbors)
 #      end
 #    end
 #  end

  #Translates the board into display values
  def show
    @board.each do |line|
      puts line.display
    end
  end

  # #Finds coordinates of all non-negative neighbors.
#   def check_neighbors(coordinate)
#     row, col = coordinate[0], coordinate[1]
#     all_neighbors = [[row + 1, col],
#     [row - 1, col],
#     [row, col + 1],
#     [row, col - 1],
#     [row + 1, col - 1],
#     [row - 1, col + 1],
#     [row - 1, col - 1],
#     [row + 1, col + 1]]
#
#     all_neighbors.map! do |coord_pair|
#       coord_pair.any? { |coordinate|  coordinate < 0 }
#         coord_pair = nil
#       end
#
#
#     all_neighbors.compact
#   end
#
#   #Finds count of neighbors.
#   def bombed_neighbors(all_neighbors)
#     bombs = 0
#     all_neighbors.each do |coord|
#       bombs += 1 if @board[coord[0]][coord[1]].bombed
#     end
#     return bombs
#   end

end

class Tile
  attr_accessor :bombed, :flagged, :revealed, :near_bombs

  def initialize(board, coord)
    @board = board
    @coord = coord
    @bombed = false
    @flagged = false
    @revealed = false
    nil
  end

  def neighbors
    row, col = @coord

    all_neighbors = [[row + 1, col],
                    [row - 1, col],
                    [row, col + 1],
                    [row, col - 1],
                    [row + 1, col - 1],
                    [row - 1, col + 1],
                    [row - 1, col - 1],
                    [row + 1, col + 1]]
    all_neighbors.select { |c| c[0] >= 0 && c[1] >= 0 &&  c[0] < 4 && c[1] < 4 }
                 .map do |coord|
      @board[coord]
    end
  end
  #
  # def valid_position?(coord)
  #   @board.valid?(coord)
  # end

  def reveal
    @revealed = true
    return if bomb_count > 0
    neighbors.each { |n| n.reveal unless n.revealed? }
  end

  def bomb_count
    near_bombs = 0
    neighbors.each { |n| near_bombs += 1 if n.bombed? }
    near_bombs
  end

  def bombed?
    @bombed
  end

  def revealed?
    @revealed
  end

  def to_s
    if @revealed && @bombed
      return 'B'
    elsif @revealed && @bombed == false
      return bomb_count
    elsif @flagged
      return 'F'
    end
    return '_'
  end

end

class Game
  attr_accessor :bombs, :minefield

  def initialize
    @board_data = ask_size
    @minefield = Board.new(@board_data[0], @board_data[1], @board_data[2])
  end

  def run
    @minefield.show
    until won? || lost?
      input

      @minefield.show
    end
    puts "You lost" if lost?
  end



  def input
    entry = nil
    until valid?(entry)
      puts "\n"
      puts 'Choose a coordinate and indicate (f)lag or (s)earch. e.g. 2-3-f:'
      entry = gets.chomp
    end
    entry = entry.split('-')
    if entry.last == 's'
      search(entry[0], entry[1])
    end
    entry
  end

  def valid?(inp)
    true unless inp == nil
  end

  def search(row, col)
    @minefield.board[row.to_i][col.to_i].revealed = true
  end


  def ask_size
    puts "How many rows should the board have?: "
    rows = gets.chomp.to_i
    puts "How many columns should the board have?: "
    cols = gets.chomp.to_i
    puts "How many bombs do you want? " #later, a ratio for difficulty level
    @bombs = gets.chomp.to_i
    [rows, cols, @bombs]
  end

  def won?
    good_guesses = @minefield.board.flatten.select do |tile|
      tile.flagged && tile.bombed
    end
    good_guesses.length == @bombs
  end

  def lost?
    @minefield.board.flatten.any? do |tile|
      tile.revealed && tile.bombed
    end
  end
end

# Game.new.run

b = Board.new(4,4,2)
b.show
b.board[0][0].reveal
b.show