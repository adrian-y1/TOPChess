# frozen_string_literal: true

require_relative '../lib/game_pieces/rook'
require_relative '../lib/game_pieces/queen'
require_relative '../lib/game_pieces/bishop'
require_relative './board_setup'
require 'colorize'
require 'matrix'

# Class the defines the board of the game and it's respective methods
class Board
  attr_accessor :board
  attr_reader :pieces

  def initialize
    @board = Array.new(8) { Array.new(8) { ' ' } }
    @removed_pieces = []
    @pieces = {}
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
    p column
    [8 - square.split('')[1].to_i, column[1]]
  end

  # Turns a given square's index to coordingate (e.g. [4, 0] = a4)
  def square_index_to_coordinates(square)
    number_to_letter = (0..7).zip('a'..'h')
    column = number_to_letter.select { |i| i[0] == square[1] }.flatten
    "#{column[1]}#{8 - square[0]}"
  end

  def make_promotion(player)
    if promotion_available?(player)
      # ask user to choose between Queen, Rook, Bishop and Knight
      chosen_piece = 'to be created later...'
      # create a new object with the chosen piece e.g. Piece.new(player.color)
      promotion_piece = create_chosen_piece(player, chosen_piece)
      # Find promotable pawn
      promotable_pawn = find_promotable_pawn(player)
      # Set that new piece object to the position of the promotable pawn
      @board[promotable_pawn[0]][promotable_pawn[1]] = promotion_piece
    end
  end

  # Checks if a promotion is available
  def promotion_available?(player)
    row = promotion_row(player)
    @board[row].any? do |col|
      col.is_a?(Pawn) && col.color == player.color
    end
  end

  # Creates a new obj and class instance of the chosen piece
  def create_chosen_piece(player, chosen_piece)
    case chosen_piece
    when 'Queen'
      Queen.new(player.color)
    when 'Bishop'
      Bishop.new(player.color)
    when 'Rook'
      Rook.new(player.color)
    when 'Knight'
      Knight.new(player.color)
    end
  end

  # Finds the promotable Pawn square
  def find_promotable_pawn(player)
    row = promotion_row(player)
    @board[row].each do |col|
      square = Matrix[*@board].index(col)
      return square if col.is_a?(Pawn) && col.color == player.color
    end
  end

  # Finds the promotion row depending on the player
  def promotion_row(player)
    player.color == :blue ? 7 : 0
  end

  def setup_board
    BoardSetup.new(@board)
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

  # Removes the pieces at the given index and stores it in an array of removed pieces
  def remove_piece(index)
    @removed_pieces.push(@board[index[0]][index[1]])
    @board[index[0]][index[1]] = ' '
  end

  def change_square_bg(row, column, square)
    if row.even?
      print column.even? ? square.on_white : square.on_black
    else
      print column.odd? ? square.on_white : square.on_black
    end
  end
end
