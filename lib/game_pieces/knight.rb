# frozen_string_literal: true

require_relative '../modules/validate_moves'

# Class that creates a Knight
class Knight
  attr_reader :color, :colored_symbol, :valid_moves

  include ValidateMoves

  def initialize(color)
    @symbol = " \u265E "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @movement = [[-2, -1], [-2, 1], [-1, 2], [-1, -2], [1, 2], [1, -2], [2, 1], [2, -1]]
    @valid_moves = []
  end

  # Creates all the valid moves the knight can go to, given a square
  def create_all_moves(square, board)
    @movement.each do |move|
      next_square = [square[0] + move[0], square[1] + move[1]]
      next unless inside_board?(next_square)

      board_square = board.board[next_square[0]][next_square[1]]
      next if occupied_by_own_self?(board_square, @color)

      @valid_moves.push(next_square)
      next if occupied_by_opponent?(board_square, @color)
    end
    @valid_moves
  end
end
