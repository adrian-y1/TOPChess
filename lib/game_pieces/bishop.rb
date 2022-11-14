# frozen_string_literal: true

require_relative '../modules/validate_moves'

# Class that creates the Bishop
class Bishop
  attr_reader :color, :colored_symbol

  include ValidateMoves

  def initialize(color)
    @symbol = " \u265D "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
    @movement = [[-1, -1], [1, -1], [-1, 1], [1, 1]]
  end

  # Creates all the possible valid moves the Bishop can move to
  # given a square and directional movement (top left, bottom left, bottom right, top right).
  def create_diagonal_moves(square, moves, board)
    loop do
      next_square = [moves[0] + square[0], moves[1] + square[1]]
      return @valid_moves unless inside_board?(next_square)

      update_movement(moves)
      board_square = board.board[next_square[0]][next_square[1]]
      return @valid_moves if occupied_by_own_self?(board_square, @color)

      @valid_moves.push(next_square)
      return @valid_moves if occupied_by_opponent?(board_square, @color)
    end
  end

  # Creates all the diagonal moves the Bishop can make
  def create_all_moves(square, board)
    @movement.each { |move| create_diagonal_moves(square, move, board) }
    @valid_moves
  end
end
