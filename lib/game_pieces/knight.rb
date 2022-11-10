# frozen_string_literal: true

# Class that creates a Knight
class Knight
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265E "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @moves = [[-2, -1], [-2, 1], [-1, 2], [-1, -2], [1, 2], [1, -2], [2, 1], [2, -1]]
  end

  # Creates all the moves the knight can go to, given a square
  def create_possible_moves(square)
    possible_moves = []
    @moves.each do |move|
      possible_moves.push([square[0] + move[0], square[1] + move[1]])
    end
    possible_moves
  end

  # Finds all the moves from #create_possible_moves that do not go out of bounds, given a square
  def create_all_moves(square)
    possible_moves = create_possible_moves(square)
    possible_moves.select { |x, y| [x, y] if x.between?(0, 7) && y.between?(0, 7) }
  end
end
