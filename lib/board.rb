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

  def checkmate?(player)
    king_in_check?(player) &&
      !move_to_safe_position?(player) &&
      !checking_piece_capturable?(player) &&
      !interception_available?(player)
  end

  # Checks if current player is in check
  def king_in_check?(current_player)
    current_player_king = find_player_king(current_player)
    opponent = find_opponent_color(current_player)
    opponent_pieces = find_player_pieces(opponent)
    opponent_pieces.any? { |obj| obj[:piece].valid_moves.flatten(1).include?(current_player_king) }
  end

  # Checks if the King can move to safe position
  def move_to_safe_position?(player)
    valid_king_moves = remove_guarded_king_moves(player)
    !valid_king_moves.empty?
  end

  # When King is in check, it checks whether or not the opponent's pieces
  # that are checking the King are capturable
  def checking_piece_capturable?(player)
    checking_piece_square = find_checking_piece_class(player)
    return false if checking_piece_square.length > 1
    unguarded_squares = checking_piece_square.map {|obj| obj[:current_square] unless obj[:piece].defended }
    player_pieces = find_player_pieces(player.color)
    current_player_moves = player_pieces.map { |obj| obj[:piece].valid_moves }.flatten(1)
    current_player_moves.any? { |move| unguarded_squares.any? { |square| move.include?(square) } }
  end

  # Returns true if there are any available squares to intercept a check
  # Returns false otherwise
  def interception_available?(player)
    available_interceptions = find_available_interceptions(player)
    player_pieces = find_player_pieces(player.color)
    player_pieces.each { |obj| player_pieces.delete(obj) if obj[:piece].is_a?(King) }
    current_player_moves = player_pieces.map { |obj| obj[:piece].valid_moves }.flatten(2)
    current_player_moves ? current_player_moves.any? { |move| available_interceptions.include?(move) } : false
  end

  # Finds the checking piece(s)'s entire object
  # Store inside array if the object's class is a Queen, Rook or Bishop
  def find_checking_piece_class(player)
    checking_piece_square = find_checking_piece_square(player)
    opponent = find_opponent_color(player)
    opponent_moves = find_player_pieces(opponent)
    checking_piece_square.each_with_object([]) do |square, checking_piece|
      piece_obj = opponent_moves.select { |move| move[:current_square] == square }
      piece_obj.each do |piece|
        if piece[:piece].is_a?(Queen) || piece[:piece].is_a?(Rook) || piece[:piece].is_a?(Bishop)
          checking_piece << piece
        end
      end
    end
  end

  # Finds all the available squares that can be intercepted to remove the check
  # Returns empty array if there are more than 1 piece checking the King
  def find_available_interceptions(player)
    player_king = find_player_king(player)
    piece_class_obj = find_checking_piece_class(player)
    return [] if piece_class_obj.length > 1

    intercepting_squares = []
    piece_class_obj.each do |piece|
      piece[:piece].valid_moves.each do |moves|
        intercepting_squares << moves if moves.include?(player_king)
      end
    end
    intercepting_squares.flatten!(1)
    intercepting_squares.delete(player_king)
    intercepting_squares
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

  # Removes any king's moves that are guarded by opponent and
  # any moves that can capture an opponent's piece but are defended by another piece
  def remove_guarded_king_moves(player)
    player_king = find_player_king(player)
    opponent = find_opponent_color(player)
    opponent_pieces = find_player_pieces(opponent)
    player_king_moves = @board[player_king[0]][player_king[1]].create_all_moves(player_king, self).flatten(1)
    temp = []
    opponent_pieces.each do |piece|
      player_king_moves.each do |move|
        temp << move if move == piece[:current_square] && piece[:piece].defended
        temp << move if piece[:piece].attacking_squares.any? { |attk| attk.include?(move) }
      end
    end
    player_king_moves - temp.uniq
  end

  # When King is in check, it finds the square of opponent's pieces
  # that are checking the King
  def find_checking_piece_square(player)
    opponent = find_opponent_color(player)
    opponent_pieces = find_player_pieces(opponent)
    player_king = find_player_king(player)
    opponent_pieces.each_with_object([]) do |piece, checking_piece_square|
      next unless piece[:piece].valid_moves.any? { |move| move.include?(player_king) }

      checking_piece_square << piece[:current_square]
    end
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
