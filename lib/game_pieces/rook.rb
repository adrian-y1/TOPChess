# frozen_string_literal: true

require_relative '../modules/validate_moves.rb'

# Class that creates the Rook
class Rook
  attr_reader :color, :colored_symbol

  include ValidateMoves

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
  def create_row_moves(square, moves, board)
    loop do
      column = square[1] + moves[1]
      return @valid_moves unless column.between?(0, 7)

      next_square = [moves[0] + square[0], moves[1] + square[1]]
      moves[1].positive? ? moves[1] += 1 : moves[1] -= 1
      board_square = board.board[next_square[0]][next_square[1]]
      return @valid_moves if occupied_by_own_self?(board_square)
      @valid_moves.push(next_square)
      return @valid_moves if occupied_by_opponent?(board_square)
    end
  end

  # Creates all the possible moves the Rook can move to in
  # the column of a given square and direction (top or bottom).
  # If the row of the move is a positive integer, move up to the next row,
  # Else, move down the row before
  def create_column_moves(square, moves, board)
    loop do
      row = square[0] + moves[0]
      return @valid_moves unless row.between?(0, 7)

      next_square = [moves[0] + square[0], moves[1] + square[1]]
      moves[0].positive? ? moves[0] += 1 : moves[0] -= 1
      board_square = board.board[next_square[0]][next_square[1]]
      return @valid_moves if occupied_by_own_self?(board_square)

      @valid_moves.push(next_square)
      return @valid_moves if occupied_by_opponent?(board_square)
    end
  end

  # Creates the left, right, top and bottom moves for the Rook
  def create_all_moves(square, board)
    left_moves = create_row_moves(square, [0, -1], board)
    right_moves = create_row_moves(square, [0, 1], board)
    top_moves = create_column_moves(square, [-1, 0], board)
    bottom_moves = create_column_moves(square, [1, 0], board)
    @valid_moves
  end
end
