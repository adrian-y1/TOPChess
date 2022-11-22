# frozen_string_literal: true

require_relative '../lib/game_pieces/rook'
require_relative '../lib/game_pieces/queen'
require_relative '../lib/game_pieces/bishop'
require_relative '../lib/modules/validate_moves'
require 'colorize'
require 'matrix'

# Class the defines the board of the game and it's respective methods
class Board
  attr_accessor :board
  attr_reader :pieces

  include ValidateMoves

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
    [8 - square.split('')[1].to_i, column[1]]
  end

  # Finds all the available squares that can be intercepted to remove the check
  # Returns empty array if there are more than 1 piece checking the King
  def find_available_interceptions(player)
    player_king = find_player_king(player)[0][:current_square]
    interceptable_pieces = find_interceptable_pieces(player).compact
    interceptable_squares = []
    return [] if interceptable_pieces.empty? || find_checking_piece(player).length > 1

    interceptable_pieces.each do |obj|
      obj[:piece].valid_moves.each { |moves| interceptable_squares << moves if moves.include?(player_king) }
    end
    interceptable_squares.flatten!(1)
    interceptable_squares.delete(player_king)
    interceptable_squares
  end

  # Returns an array of hashes of piece objects that are interceptable
  # Only interceptable pieces are Rook, Queen and Bishop
  def find_interceptable_pieces(player)
    checking_piece = find_checking_piece(player)
    checking_piece.map do |obj|
      obj if obj[:piece].is_a?(Queen) || obj[:piece].is_a?(Rook) || obj[:piece].is_a?(Bishop)
    end
  end

  # Checks if the King can move to a safe position
  def move_to_safe_position?(player)
    opponent = find_opponent_color(player)
    opponent_pieces = find_player_pieces(opponent)
    valid_king_moves = remove_guarded_king_moves(player, opponent_pieces).uniq
    !valid_king_moves.empty?
  end

  # Removes any king's moves that are guarded by opponent and
  # any moves that can capture an opponent's piece but are defended by another piece
  def remove_guarded_king_moves(player, opponent_pieces)
    player_king_moves = find_player_king(player)[0][:piece].valid_moves.flatten(1)
    invalid_moves = []
    opponent_pieces.each do |obj|
      player_king_moves.each do |move|
        invalid_moves << move if move == obj[:current_square] && obj[:piece].defended
        invalid_moves << move if obj[:piece].attacking_squares.any? { |sq| sq.include?(move) }
      end
    end
    player_king_moves - invalid_moves.uniq
  end

  # Returns an array of hashes of class instances of the piece(s) checking
  # the current player's King
  def find_checking_piece(player)
    opponent = find_opponent_color(player)
    opponent_pieces = find_player_pieces(opponent)
    current_player_king = find_player_king(player)[0]
    opponent_pieces.each_with_object([]) do |obj, checking_piece|
      next unless obj[:piece].valid_moves.any? { |move| move.include?(current_player_king[:current_square]) }

      checking_piece << obj
    end
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

  # private

  # Removes the pieces at the given index and stores it in an array of removed pieces
  def remove_piece(index)
    @removed_pieces.push(@board[index[0]][index[1]])
    @board[index[0]][index[1]] = ' '
  end

  # Finds the class instance of the current player's King and current square
  def find_player_king(player)
    player_pieces = find_player_pieces(player.color)
    player_pieces.select {|obj| obj[:piece].is_a?(King) }
  end

  # Finds the given player's pieces on the board and their current square
  def find_player_pieces(player)
    @board.each_with_object([]) do |row, pieces|
      row.each do |column|
        next unless occupied_by_own_self?(column, player)

        current_square = Matrix[*@board].index(column)
        column.create_all_moves(current_square, self)
        pieces << { piece: column, current_square: current_square }
      end
    end
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
