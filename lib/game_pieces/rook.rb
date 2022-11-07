# frozen_string_literal: true

class Rook
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265C "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
  end

  # Creates all the possible moves the Rook can move to in
  # the row of it's current square.
  # If the column of the move is a positive integer, move up to the next column
  # Else, move down to the column before
  def create_row_moves(square, moves)
    loop do
      return @valid_moves if !(square[1] + moves[1]).between?(0, 7)
      new_square = [moves[0] + square[0], moves[1] + square[1]]
      moves[1].positive? ? moves[1] += 1 : moves[1] -= 1
      @valid_moves.push(new_square)
    end
  end

  # Creates all the possible moves the Rook can move to in
  # the column of it's current square.
  # If the row of the move is a positive integer, move up to the next row,
  # Else, move down the row before
  def create_column_moves(square, moves)
    loop do
      return @valid_moves if !(square[0] + moves[0]).between?(0, 7)
      new_square = [moves[0] + square[0], moves[1] + square[1]]
      moves[0].positive? ? moves[0] += 1 : moves[0] -= 1
      @valid_moves.push(new_square)
    end
  end

  # Creates the left, right, top and bottom possible moves for the Rook
  # The 2nd arg is how the Rook moves to a nearby square in a certain direction
  def create_valid_moves(square)
    left_moves = create_row_moves(square, [0, -1])
    right_moves = create_row_moves(square, [0, 1])
    top_moves = create_column_moves(square, [-1, 0])
    bottom_moves = create_column_moves(square, [1, 0])
    @valid_moves
  end
end
