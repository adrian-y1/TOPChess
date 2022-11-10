# frozen_string_literal: true

require 'colorize'
require 'matrix'

# Class the defines the board of the game and it's respective methods
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) { ' ' } }
    @removed_pieces = []
  end

  # Checks if current player is in check
  def king_in_check?(current_player)
    current_player_king = find_king(current_player)
    piece_moves = find_opponent_moves(current_player)
    piece_moves.any? {|move| move.include?(current_player_king)}
  end

  def find_opponent_moves(current_player)
    opponent_pieces = find_opponent_pieces(current_player)
    piece_moves = []
    opponent_pieces.each do |key, val|
      if key.is_a?(Pawn)
        piece_moves.push(key.create_all_moves(val, self))
      else
        piece_moves.push(key.create_all_moves(val))
      end
    end
    piece_moves
  end

  # Given the position of a piece, move that piece to the given destination
  # Once moved, change it's previous position to empty str
  def move(piece_coordinates, destination)
    piece_square = find_coordinates_index(piece_coordinates)
    destination_square = find_coordinates_index(destination)
    @board[destination_square[0]][destination_square[1]] = @board[piece_square[0]][piece_square[1]]
    remove_piece(piece_square)
  end

  # Checks if a given square can be moved to
  def free?(square, current_player)
    sq_index = find_coordinates_index(square)
    @board[sq_index[0]][sq_index[1]] == ' ' || @board[sq_index[0]][sq_index[1]].color != current_player.color
  end

  # Returns the row and column of a given square coordinate(e.g. a4 = [4, 0])
  def find_coordinates_index(square)
    letter_to_number = ('a'..'h').zip(0..7)
    column = letter_to_number.select { |i| i[0] == square.split('')[0] }.flatten
    [8 - square.split('')[1].to_i, column[1]]
  end

  # Removes the pieces at the given index and stores it in an array of removed pieces
  def remove_piece(index)
    @removed_pieces.push(@board[index[0]][index[1]])
    @board[index[0]][index[1]] = ' '
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

  private 

  # Finds the index position of the current player's King
  def find_king(current_player)
    (0..7).each do |row|
      (0..7).each do |column|
        square = @board[row][column]
        return [row, column] if square.is_a?(King) && square.color == current_player.color
      end
    end
  end

  # Finds opponent's pieces and their current square
  def find_opponent_pieces(current_player)
    opponent = find_opponent_color(current_player)
    opponent_pieces = {}
    @board.each do |row|
      row.each do |column|
        opponent_pieces[column] = Matrix[*@board].index(column) if column != ' ' && column.color == opponent
      end
    end
    opponent_pieces
  end

  def find_opponent_color(current_player)
    current_player.color == :blue ? :red : :blue
  end

  def change_square_bg(row, column, square)
    if row.even?
      print column.even? ? square.on_white : square.on_black
    else
      print column.odd? ? square.on_white : square.on_black
    end
  end
end
