# frozen_string_literal: true

require 'colorize'

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

  def inside_board?(square)
    square[0].between?(0, 7) && square[1].between?(0, 7)
  end
end
