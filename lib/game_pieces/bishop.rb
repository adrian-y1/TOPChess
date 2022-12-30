# frozen_string_literal: true

require_relative '../modules/validate_moves'

# Class that creates the Bishop
class Bishop
  attr_reader :color, :valid_moves, :attacking_squares
  attr_accessor :defended, :colored_symbol

  include ValidateMoves

  def initialize(color)
    @symbol = " \u265D "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
    @movement = [[-1, -1], [1, -1], [-1, 1], [1, 1]]
    @defended = false
    @attacking_squares = @valid_moves
  end

  # Creates all the possible valid moves the Bishop can move to
  # given a square and directional movement (top left, bottom left, bottom right, top right).
  def create_diagonal_moves(square, moves, board)
    valid_moves = []
    loop do
      next_square = [moves[0] + square[0], moves[1] + square[1]]
      return valid_moves unless inside_board?(next_square)

      update_movement(moves)
      board_square = board.board[next_square[0]][next_square[1]]
      if occupied_by_own_self?(board_square, @color)
        board_square.defended = true
        return valid_moves
      end

      valid_moves.push(next_square)
      return valid_moves if occupied_by_opponent?(board_square, @color)
    end
  end

  # Creates all the diagonal moves the Bishop can make
  def create_all_moves(square, board)
    valid_moves = []
    movement_copy = Marshal.load(Marshal.dump(@movement))
    movement_copy.each do |move|
      new_moves = create_diagonal_moves(square, move, board)
      valid_moves << new_moves unless new_moves.empty?
    end
    valid_moves
  end

  def create_valid_moves(square, board)
    @valid_moves = create_all_moves(square, board)
    @attacking_squares = @valid_moves
  end
end
