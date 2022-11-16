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
    current_player_king = find_player_king(current_player)
    opponent = find_opponent_color(current_player)
    opponent_moves = find_player_moves(opponent)
    opponent_moves.any? { |move| move.include?(current_player_king) }
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

  # When King is in check, it checks whether or not the opponent's pieces
  # that are checking the King are capturable
  def checking_piece_capturable?(player)
    checking_piece_square = find_checking_piece_square(player)
    current_player_moves = find_player_moves(player.color)
    current_player_moves.any? { |move| checking_piece_square.any? { |square| move.include?(square) } }
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

  # When King is in check, it finds the square of opponent's pieces 
  # that are checking the King
  def find_checking_piece_square(player)
    opponent = find_opponent_color(player)
    find_player_moves(opponent)
    player_king = find_player_king(player)
    checking_piece_square = []
    @pieces.each do |key, val|
      checking_piece_square << val if key.valid_moves.include?(player_king)
    end
    checking_piece_square
  end

  # Removes the pieces at the given index and stores it in an array of removed pieces
  def remove_piece(index)
    @removed_pieces.push(@board[index[0]][index[1]])
    @board[index[0]][index[1]] = ' '
  end

  # Finds the index position of the current player's King
  def find_player_king(player)
    (0..7).each do |row|
      (0..7).each do |column|
        square = @board[row][column]
        return [row, column] if square.is_a?(King) && square.color == player.color
      end
    end
  end

  # Finds the given player's possible moves
  def find_player_moves(player)
    @pieces = find_player_pieces(player)
    @pieces.map { |key, val| key.create_all_moves(val, self) }
  end

  # Finds the given player's pieces on the board and their current square
  def find_player_pieces(player)
    pieces = {}
    @board.each do |row|
      row.each do |column|
        pieces[column] = Matrix[*@board].index(column) if column != ' ' && column.color == player
      end
    end
    pieces
  end

  # Returns opponent's color
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
