# frozen_string_literal: true

# Class that creates the Bishop
class Bishop
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265D "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
  end

  # Creates all the possible valid moves the Bishop can move to 
  # given a square and directional movement.
  # If the row is a positive integer, move up to the next row,
  # Else, move down to the row before. Same rules apply for the column
  def create_possible_moves(square, moves)
    loop do
      row = square[0] + moves[0]
      column = square[1] + moves[1]
      return @valid_moves unless row.between?(0, 7) && column.between?(0, 7)

      next_square = [moves[0] + square[0], moves[1] + square[1]]
      moves[1].positive? ? moves[1] += 1 : moves[1] -= 1
      moves[0].positive? ? moves[0] += 1 : moves[0] -= 1
      @valid_moves.push(next_square)
    end
  end

  def create_valid_moves(square)
    top_left = create_possible_moves(square, [-1, -1])
    bottom_left = create_possible_moves(square, [1, -1])
    top_right = create_possible_moves(square, [-1, 1])
    bottom_right = create_possible_moves(square, [1, 1])
    @valid_moves
  end
end
