# frozen_string_literal: true
require 'colorize'

# Class the defines the board of the game and it's respective methods
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) {' '}}
  end

  def display
    letters = '   A  B  C  D  E  F  G  H'
    puts letters
    @board.each_index do |r|
      print "#{8 - r} "
      @board[r].each_index do |c|
        square = @board[r][c] == ' ' ? "#{@board[r][c]}  " : @board[r][c].colored_symbol
        change_square_bg(r, c, square)
      end
      print " #{8 - r}\n"
    end
    puts letters
  end

  def change_square_bg(row, column, square)
    if row.even?
      print column.even? ? square.on_white : square.on_black
    else
      print column.odd? ? square.on_white : square.on_black
    end
  end
end
