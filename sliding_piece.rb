require './Chess.rb'

class Array

  def merge_sum
    self.transpose.map {|x| x.reduce(:+)}
  end

end

class SlidingPiece < Piece
  def moves

  end

  def cardinal_dirs
    cards = []
    origin = @position

   7.times do
    cards << [origin, NORTH].merge_sum
    origin = [origin, NORTH].merge_sum
   end
  end

  def diagonal_dirs

  end
  #
  # def find_moves_linear(direction)
  #   moves = []
  #   7.times do
  #     moves << origin[0], origin[1] += direction[0]
  #     moves <<  += direction[1]
  #   end

end



