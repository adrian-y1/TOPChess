# frozen_string_literal: true

require 'colorize'

# Class the defines the board of the game and it's respective methods
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) { ' ' } }
  end

  # Given the piece position of a piece, move that piece to the given destination
  # once moved, change it's previous position to empty str
  def move(piece, destination)
    piece_square = find_coordinates_index(piece)
    destination_square = find_coordinates_index(destination)
    @board[destination_square[0]][destination_square[1]] = @board[piece_square[0]][piece_square[1]]
    @board[piece_square[0]][piece_square[1]] = ' '
  end

  # Returns the row and column of a given square (e.g. a4 = [4, 0])
  def find_coordinates_index(square)
    letter_to_number = ('a'..'h').zip(0..7)
    column = letter_to_number.select { |i| i[0] == square.split('')[0] }.flatten
    [8 - square.split('')[1].to_i, column[1]]
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
# board = Board.new
# king = " \u265A "
# queen = " \u265B "
# rook = " \u265C "
# bishop = " \u265D "
# knight = " \u265E "
# pawn = " \u265F "
# board.board[0][0] = rook.blue
# board.board[0][7] = rook.blue
# board.board[0][1] = knight.blue
# board.board[0][6] = knight.blue
# board.board[0][2] = bishop.blue
# board.board[0][5] = bishop.blue
# board.board[0][3] = queen.blue
# board.board[0][4] = king.blue
# (0..7).each {|i| board.board[1][i] = pawn.blue}

# board.board[7][0] = rook.red
# board.board[7][7] = rook.red
# board.board[7][1] = knight.red
# board.board[7][6] = knight.red
# board.board[7][2] = bishop.red
# board.board[7][5] = bishop.red
# board.board[7][3] = queen.red
# board.board[7][4] = king.red
# (0..7).each {|i| board.board[6][i] = pawn.red}
# board.display
