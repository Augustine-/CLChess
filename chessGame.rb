require "./chess.rb"

class Game
  attr_accessor :boardgame
  def initialize
    @boardgame = Board.new
    @player1 = HumanPlayer.new("red", "augustine", self)
    @player2 = HumanPlayer.new("blue", "coburn", self)
    puts "Welcome to extreme chess!"
    puts "Please enter your move, use the following format: "
    puts "For the x-axis, use the letters 'a' through 'h'... "
    puts "...and use the numbers 0 through 7 for the Y axis!"
    puts "e.g. 'f2, f3'"
    puts "\n"
  end

  def play
    until @boardgame.checkmate?("red") || @boardgame.checkmate?("blue")
      @boardgame.render

      @player1.play_turn
      @boardgame.render
      @player2.play_turn
    end
  end



end

class Player
end

class HumanPlayer
  attr_accessor :color

  def initialize(color, name, game)
    @game = game
    @color = color
    @name = name
  end

  def input

      puts "Please enter your move, #{@name}: "
      gets.chomp.downcase

  end


  def play_turn
    begin
      input = self.input
      better_input = input.gsub!(',','').split(' ')
      x, y = better_input[0], better_input[1]
      p x
      p y
     x = x.split('')
     y = y.split('')
     x[1], x[0] = CHESSNOTATION[x[0].to_sym], x[1].to_i
     # x[0] += y[0]
#      x[1] += y[1]
     y[1], y[0]  = CHESSNOTATION[y[0].to_sym], y[1].to_i

     p x
     p y
     @game.boardgame.move_piece(x,y, self.color)
   rescue => e
     puts e.message
     retry
   end
  end

  def valid?
  end

end

g = Game.new
 g.play