# frozen_string_literal: true

class Queen
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265B "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
  end

  # Creates all the diagonal moves the Queen can move to 
  # given a square and directional movement (top left, bottom left, bottom right, top right).
  # If the row is a positive integer, move up to the next row,
  # Else, move down to the row before. Same rules apply for the column
  def create_diagonal_moves(square, moves)
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

  # Creates all the possible moves the Queen can move to in
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

  # Creates all the possible moves the Queen can move to in
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

  # Creates all the moves in all of the directions for the Queen
  def create_all_moves(square)
    left = create_row_moves(square, [0, -1])
    right = create_row_moves(square, [0, 1])
    top = create_column_moves(square, [-1, 0])
    bottom = create_column_moves(square, [1, 0])
    top_left = create_diagonal_moves(square, [-1, -1])
    bottom_left = create_diagonal_moves(square, [1, -1])
    top_right = create_diagonal_moves(square, [-1, 1])
    bottom_right = create_diagonal_moves(square, [1, 1])
    @valid_moves
  end
end
