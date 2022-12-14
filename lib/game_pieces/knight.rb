# frozen_string_literal: true

require_relative '../modules/validate_moves'

# Class that creates a Knight
class Knight
  attr_reader :color, :valid_moves, :attacking_squares
  attr_accessor :defended, :colored_symbol

  include ValidateMoves

  def initialize(color)
    @symbol = " \u265E "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @movement = [[-2, -1], [-2, 1], [-1, 2], [-1, -2], [1, 2], [1, -2], [2, 1], [2, -1]]
    @valid_moves = []
    @defended = false
    @attacking_squares = @valid_moves
  end

  # Creates all the valid moves the knight can go to, given a square
  def create_all_moves(square, board)
    valid_moves = []
    movement_copy = Marshal.load(Marshal.dump(@movement))
    movement_copy.each do |move|
      next_square = [square[0] + move[0], square[1] + move[1]]
      next unless inside_board?(next_square)

      board_square = board.board[next_square[0]][next_square[1]]
      if occupied_by_own_self?(board_square, @color)
        board_square.defended = true
        next valid_moves
      end

      valid_moves.push([next_square])
      next if occupied_by_opponent?(board_square, @color)
    end
    valid_moves
  end

  def create_valid_moves(square, board)
    @valid_moves = create_all_moves(square, board)
    @attacking_squares = @valid_moves
  end
end
