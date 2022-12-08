# frozen_string_literal: true

require_relative '../lib/modules/validate_moves'
require 'matrix'

# Class that determines wins, draws, losses
class EndGame
  attr_accessor :board

  include ValidateMoves

  def initialize(board)
    @board = board
  end

  # Checks if the player is checkmated or not
  def checkmate?(player)
    king_in_check?(player) &&
      !move_to_safe_position?(player) &&
      !checking_piece_capturable?(player) &&
      !interception_available?(player)
  end

  # If the player has no legal moves to make and is not in check
  # returns true
  def stalemate?(player)
    !king_in_check?(player) &&
      !move_to_safe_position?(player) &&
      !checking_piece_capturable?(player) &&
      !interception_available?(player) &&
      @board.find_available_piece_coordinates(player, self).empty?
  end

  # Finds out if the King is in check or not
  def king_in_check?(player)
    player_king = find_player_king(player)[:current_square]
    opponent = find_opponent_color(player)
    opponent_pieces = find_player_pieces(opponent)
    opponent_pieces.any? { |obj| obj[:piece].valid_moves.flatten(1).include?(player_king) }
  end

  # When there are more than 1 piece checking the King,
  # this method checks if any of those pieces can be captured by the King
  def capturable_by_king?(player, checking_piece)
    undefended_squares = checking_piece.map { |obj| obj[:current_square] unless obj[:piece].defended }
    player_king_moves = find_player_king(player)[:piece].valid_moves.flatten(1).uniq

    player_king_moves.any? do |move|
      undefended_squares.include?(move)
    end
  end

  # Returns true if the checking piece can be captured
  # Returns false if the checking piece is not capture or
  # if there are more than 1 checking piece or non_king_moves returns nil, returns whether or not
  # The king can capture the piece
  def checking_piece_capturable?(player)
    checking_piece = find_checking_piece(player)
    opponent_squares = checking_piece.map { |obj| obj[:current_square] }
    player_valid_moves = none_king_player_moves(player)
    return capturable_by_king?(player, checking_piece) if checking_piece.length > 1 || player_valid_moves.nil?

    player_valid_moves.any? { |move| opponent_squares.include?(move) }
  end

  # Checks if the current player can intercept opponent's checking piece to remove the check
  def interception_available?(player)
    available_interceptions = find_available_interceptions(player)
    player_valid_moves = none_king_player_moves(player)
    player_valid_moves ? player_valid_moves.any? { |move| available_interceptions.include?(move) } : false
  end

  # Checks if the King can move to a safe position
  def move_to_safe_position?(player)
    opponent = find_opponent_color(player)
    opponent_pieces = find_player_pieces(opponent)
    valid_king_moves = remove_guarded_king_moves(player, opponent_pieces).uniq
    !valid_king_moves.empty?
  end

  # Finds all the available squares that can be intercepted to remove the check
  # Returns empty array if there are more than 1 piece checking the King
  def find_available_interceptions(player)
    player_king = find_player_king(player)[:current_square]
    interceptable_pieces = find_interceptable_pieces(player).compact
    interceptable_squares = []
    return [] if interceptable_pieces.empty?

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
    return [] if checking_piece.length > 1

    checking_piece.map do |obj|
      obj if obj[:piece].is_a?(Queen) || obj[:piece].is_a?(Rook) || obj[:piece].is_a?(Bishop)
    end
  end

  # Removes any king's moves that are guarded by opponent and
  # any moves that can capture an opponent's piece but are defended by another piece
  def remove_guarded_king_moves(player, opponent_pieces)
    player_king_moves = find_player_king(player)[:piece].valid_moves.flatten(1)
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
    current_player_king = find_player_king(player)
    opponent_pieces.each_with_object([]) do |obj, checking_piece|
      next unless obj[:piece].valid_moves.any? { |move| move.include?(current_player_king[:current_square]) }

      checking_piece << obj
    end
  end

  # Finds current player's moves except the King's
  def none_king_player_moves(player)
    non_king_moves = []
    find_player_pieces(player.color).each do |obj|
      non_king_moves << obj[:piece].valid_moves.uniq unless obj[:piece].is_a?(King)
    end
    non_king_moves.flatten!(2)
  end

  # Finds the class instance of the current player's King and current square
  def find_player_king(player)
    player_pieces = find_player_pieces(player.color)
    player_king = player_pieces.find do |obj|
      obj[:piece].is_a?(King)
    end
    player_king.nil? ? {} : player_king
  end

  # Finds the given player's pieces on the board and their current square
  def find_player_pieces(player)
    @board.board.each_with_object([]) do |row, pieces|
      row.each do |column|
        next unless occupied_by_own_self?(column, player)
        
        current_square = Matrix[*@board.board].index(column)
        #column.create_all_moves(current_square, @board)
        pieces << { piece: column, current_square: current_square }
      end
    end
  end

  def create_player_moves(player)
    pieces = find_player_pieces(player.color)
    pieces.each do |obj|
      obj[:piece].create_all_moves(obj[:current_square], @board)
    end
  end

  # Returns opponent's color
  def find_opponent_color(current_player)
    current_player.color == :blue ? :red : :blue
  end
end
