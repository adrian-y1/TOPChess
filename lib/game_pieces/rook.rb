# frozen_string_literal: true

# Class that creates the Rook
class Rook
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265C "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
  end

  # Creates all the possible moves the Rook can move to in
  # the row of a given square and direction (left or right).
  # If the column of the move is a positive integer, move up to the next column,
  # Else, move down the column before
  def create_row_moves(square, moves)
    loop do
      column = square[1] + moves[1]
      return @valid_moves unless column.between?(0, 7)

      next_square = [moves[0] + square[0], moves[1] + square[1]]
      moves[1].positive? ? moves[1] += 1 : moves[1] -= 1
      @valid_moves.push(next_square)
    end
  end

  # Creates all the possible moves the Rook can move to in
  # the column of a given square and direction (top or bottom).
  # If the row of the move is a positive integer, move up to the next row,
  # Else, move down the row before
  def create_column_moves(square, moves)
    loop do
      row = square[0] + moves[0]
      return @valid_moves unless row.between?(0, 7)

      next_square = [moves[0] + square[0], moves[1] + square[1]]
      moves[0].positive? ? moves[0] += 1 : moves[0] -= 1
      @valid_moves.push(next_square)
    end
  end

  # Creates the left, right, top and bottom moves for the Rook
  def create_all_moves(square)
    left_moves = create_row_moves(square, [0, -1])
    right_moves = create_row_moves(square, [0, 1])
    top_moves = create_column_moves(square, [-1, 0])
    bottom_moves = create_column_moves(square, [1, 0])
    @valid_moves
  end
end
