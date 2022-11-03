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
        square = @board[r][c] == ' ' ? "#{@board[r][c]}  " : @board[r][c]
        change_square_bg(r, c, square)
      end
      print " #{8 - r}"
      puts "\n"
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

board = Board.new
king = " \u265A "
queen = " \u265B "
rook = " \u265C "
bishop = " \u265D "
knight = " \u265E "
pawn = " \u265F "
board.board[0][0] = rook.blue
board.board[0][7] = rook.blue
board.board[0][1] = knight.blue
board.board[0][6] = knight.blue
board.board[0][2] = bishop.blue
board.board[0][5] = bishop.blue
board.board[0][3] = queen.blue
board.board[0][4] = king.blue
(0..7).each {|i| board.board[1][i] = pawn.blue}

board.board[7][0] = rook.red
board.board[7][7] = rook.red
board.board[7][1] = knight.red
board.board[7][6] = knight.red
board.board[7][2] = bishop.red
board.board[7][5] = bishop.red
board.board[7][3] = queen.red
board.board[7][4] = king.red
(0..7).each {|i| board.board[6][i] = pawn.red}
board.display