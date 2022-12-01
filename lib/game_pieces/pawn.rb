# frozen_string_literal: true

require_relative '../modules/validate_moves'
require 'colorize'

# Class that creates a new Pawn
class Pawn
  attr_reader :color, :colored_symbol, :valid_moves, :attacking_squares
  attr_accessor :defended, :move_counter

  include ValidateMoves

  def initialize(color)
    @symbol = " \u265F "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
    @attacking_squares = []
    @blue_movement = [[1, -1], [1, 1]]
    @red_movement = [[-1, -1], [-1, 1]]
    @move_counter = 0
    @defended = false
  end

  # Creates all possible moves for the Pawn
  def create_all_moves(square, board)
    two_square_move(square, board)
    if @color == :red
      @red_movement.each { |move| create_diagonal_moves(square, board, move) }
    else
      @blue_movement.each { |move| create_diagonal_moves(square, board, move) }
    end
    @valid_moves
  end

  # Creates one square possible move for the Pawn depending on it's color
  def one_square_move(square, board)
    next_square = @color == :red ? [square[0] + -1, square[1]] : [square[0] + 1, square[1]]
    return @valid_moves unless inside_board?(next_square)

    board_square = board.board[next_square[0]][next_square[1]]
    board_square == ' ' ? @valid_moves.push([next_square]) : @valid_moves
  end

  # Creates 2 possible square moves for the Pawn if it's on it's starting position
  def two_square_move(square, board)
    one_square_move(square, board)
    next_square = create_second_square(square)
    return @valid_moves unless inside_board?(next_square)

    board_square = board.board[next_square[0]][next_square[1]]
    board_square == ' ' && !@valid_moves.empty? ? @valid_moves.push([next_square]) : @valid_moves
  end

  # Creates possible diagonal square capture if there's an opponent's piece on
  # the forward diagonal squares of a pawn
  def create_diagonal_moves(square, board, move)
    next_square = [square[0] + move[0], square[1] + move[1]]
    return @valid_moves unless inside_board?(next_square)

    board_square = board.board[next_square[0]][next_square[1]]

    @attacking_squares << [next_square]
    occupied_by_opponent?(board_square, @color) ? @valid_moves.push([next_square]) : @valid_moves
  end

  # Creates the 2nd square for the Pawn if it's on starting position
  def create_second_square(square)
    if @color == :red && square[0] == 6
      [square[0] + -2, square[1]]
    elsif @color == :blue && square[0] == 1
      [square[0] + 2, square[1]]
    else
      square
    end
  end
end
