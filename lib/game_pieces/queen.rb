# frozen_string_literal: true

require_relative '../modules/validate_moves'

# Class that creates the Queen
class Queen
  attr_reader :color, :colored_symbol, :valid_moves

  include ValidateMoves

  def initialize(color)
    @symbol = " \u265B "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
    @movement = [[0, -1], [0, 1], [-1, 0], [1, 0], [-1, -1], [1, -1], [-1, 1], [1, 1]]
  end

  # Creates all the 8 directional moves the Queen can move to
  # given a square and directional movement
  def create_directional_moves(square, moves, board)
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

  # Creates all the moves in all of the directions for the Queen
  def create_all_moves(square, board)
    @movement.each { |move| create_directional_moves(square, move, board) }
    @valid_moves
  end
end
