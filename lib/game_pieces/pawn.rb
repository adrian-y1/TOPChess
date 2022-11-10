# frozen_string_literal: true

require 'colorize'

# Class that creates a new Pawn
class Pawn
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265F "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @valid_moves = []
  end

  def one_square_move(square)
    next_square = if @color == :red
                    [square[0] + -1, square[1]]
                  else
                    [square[0] + 1, square[1]]
                  end
    @valid_moves.push(next_square) if inside_board?(next_square)
    @valid_moves
  end

  def two_square_move(square)
    one_square_move(square)
    if @color == :red && square[0] == 6
      next_square = [square[0] + -2, square[1]]
      @valid_moves.push(next_square) if inside_board?(next_square)
    elsif @color == :blue && square[0] == 1
      next_square = [square[0] + 2, square[1]]
      @valid_moves.push(next_square) if inside_board?(next_square)
    end
    @valid_moves
  end

  # Creates all possible moves for the Pawn
  def create_all_moves(square, board)
    two_square_move(square)
    if @color == :red
      red_diagonal_move(square, board, [-1, -1])
      red_diagonal_move(square, board, [-1, 1])
    else
      blue_diagonal_move(square, board, [1, -1])
      blue_diagonal_move(square, board, [1, 1])
    end
    @valid_moves
  end

  # Creates diagonal moves for Red (Player 2), either bottom left/right
  def red_diagonal_move(square, board, move)
    if inside_board?([square[0] + move[0], square[1] + move[1]])
      diagonal_move = [square[0] + move[0], square[1] + move[1]]
      diagonal_square = board.board[diagonal_move[0]][diagonal_move[1]]
      @valid_moves.push(diagonal_move) if available_square?(diagonal_square, :blue)
    end
    @valid_moves
  end

  # Creates diagonal moves for Blue (Player 1), either top left/right
  def blue_diagonal_move(square, board, move)
    if inside_board?([square[0] + move[0], square[1] + move[1]])
      diagonal_move = [square[0] + move[0], square[1] + move[1]]
      diagonal_square = board.board[diagonal_move[0]][diagonal_move[1]]
      @valid_moves.push(diagonal_move) if available_square?(diagonal_square, :red)
    end
    @valid_moves
  end

  # Checks if a square is not empty and occupied by opponent's piece
  def available_square?(board_square, opponent_color)
    board_square != ' ' && board_square.color == opponent_color
  end

  # Checks if a square is inside the board
  def inside_board?(square)
    square[0].between?(0, 7) && square[1].between?(0, 7)
  end
end
