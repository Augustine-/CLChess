require 'debugger'

class Board
  attr_reader :board
  def initialize(rows, columns, bombs)
    @rows = rows
    @columns = columns
    @board = set_board_area
    drop_the_bombs(bombs)
  end

  def set_board_area
    [].tap do |board|
      @columns.times do |row|
        board << Array.new(@rows) { Tile.new }
      end
    end
  end

  def drop_the_bombs(bomb_count)         #populate the board with bombs
    bomb_count.times do
      @board.sample.sample.bombed = true
    end
  end

  def show
    @board.each do |line|
      puts line.display
    end
  end

  def to_s
    size.to_s
  end
end

class Tile
  attr_accessor :bombed, :flagged, :revealed
  def initialize
    @bombed = false
    @flagged = false
    @revealed = false
    #@display =
  end

  def to_s
    if @revealed && @bombed
      return 'B'
    elsif @flagged
      return 'F'
    end
    return 'O'
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

Game.new.run