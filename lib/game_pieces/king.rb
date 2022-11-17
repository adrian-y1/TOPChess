# frozen_string_literal: true

require_relative '../modules/validate_moves'

# Class that creates the King
class King
  attr_reader :color, :colored_symbol, :valid_moves, :attacking_squares
  attr_accessor :defended

  include ValidateMoves

  def initialize(color)
    @symbol = " \u265A "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @movement = [[-1, 0], [-1, -1], [0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1]]
    @valid_moves = []
    @defended = false
    @attacking_squares = @valid_moves
  end

  def create_all_moves(square, board)
    @movement.each do |move|
      next_square = [square[0] + move[0], square[1] + move[1]]
      next unless inside_board?(next_square)

      board_square = board.board[next_square[0]][next_square[1]]
      if occupied_by_own_self?(board_square, @color)
        board_square.defended = true
        next
      end

      @valid_moves.push(next_square)
      next if occupied_by_opponent?(board_square, @color)
    end
    @valid_moves
  end
end
