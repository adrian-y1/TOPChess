# frozen_string_literal: true

require_relative '../lib/game_pieces/rook'
require_relative '../lib/game_pieces/queen'
require_relative '../lib/game_pieces/bishop'
require_relative './board_setup'
require_relative './end_of_game'
require_relative '../lib/modules/validate_moves'
require 'colorize'
require 'matrix'

# Class the defines the board of the game and it's respective methods
class Board
  attr_accessor :board
  attr_reader :last_pawn_position

  include ValidateMoves

  def initialize
    @board = Array.new(8) { Array.new(8) { ' ' } }
    @removed_pieces = []
    @last_pawn_position = nil
  end

  # Given the position of a piece, move that piece to the given destination
  # Once moved, change it's previous position to empty str
  def move(start, stop)
    start_sq = find_coordinates_index(start)
    stop_sq = find_coordinates_index(stop)
    @board[stop_sq[0]][stop_sq[1]] = @board[start_sq[0]][start_sq[1]]
    @last_pawn_position = two_square_move?(start_sq, stop_sq) ? @board[stop_sq[0]][stop_sq[1]] : nil
    remove_piece(start_sq)
  end

  # Checks if a Pawn has moved 2 squares forward
  def two_square_move?(start, destination)
    difference = (start[0] - destination[0]).abs
    difference == 2
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

  # Turns a given square's index to coordingate (e.g. [4, 0] = a4)
  def square_index_to_coordinates(square)
    number_to_letter = (0..7).zip('a'..'h')
    column = number_to_letter.select { |i| i[0] == square[1] }.flatten
    "#{column[1]}#{8 - square[0]}"
  end

  # Creates the promotion
  def make_promotion(player, chosen_piece)
    promotion_piece = create_chosen_piece(player, chosen_piece.capitalize)
    promotable_pawn = find_promotable_pawn(player)
    @board[promotable_pawn[0]][promotable_pawn[1]] = promotion_piece
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

  # Returns user friendly coordinates for available pieces to move
  def find_available_piece_coordinates(player, game_end)
    pieces = game_end.find_player_pieces(player.color)
    remove_illegal_moves(player, game_end, pieces)
    pieces_square = pieces.map { |obj| obj[:current_square] unless obj[:piece].valid_moves.empty? }.compact
    pieces_square.map { |square| square_index_to_coordinates(square) }.join(', ')
  end

  # Returns user friendly valid moves coordinates for a given piece coordinate
  def find_valid_piece_move_coordinates(piece_coordinates)
    piece_square = find_coordinates_index(piece_coordinates)
    piece_moves = @board[piece_square[0]][piece_square[1]].valid_moves.flatten(1)
    piece_moves.uniq.map { |move| square_index_to_coordinates(move) }.join(', ')
  end

  # Removes illegal moves that place the King in check from each piece's valid moves
  def remove_illegal_moves(player, game_end, player_pieces)
    player_pieces.each do |obj|
      obj[:piece].valid_moves.reverse_each do |moves_arr|
        moves_arr.reverse_each do |move|
          temp_board = Marshal.load(Marshal.dump(self))
          game_end.board = temp_board
          current_sq = obj[:current_square]
          temp_board.board[move[0]][move[1]] = temp_board.board[current_sq[0]][current_sq[1]]
          temp_board.board[current_sq[0]][current_sq[1]] = ' '
          moves_arr.delete(move) if game_end.king_in_check?(player)
        end
      end
    end
    game_end.board = self
    player_pieces.each { |obj| obj[:piece].valid_moves.reject!(&:empty?) }
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
