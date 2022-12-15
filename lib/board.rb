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
  attr_reader :removed_pieces

  include ValidateMoves

  def initialize
    @board = Array.new(8) { Array.new(8) { ' ' } }
    @removed_pieces = []
    @last_pawn_moved = nil
  end

  # Given the position of a piece, move that piece to the given destination
  # Once moved, change it's previous position to empty str
  # Also handles en passant capture and updates the last pawn moved
  def move(start, destination)
    start_square = find_coordinates_index(start)
    destination_square = find_coordinates_index(destination)
    @board[destination_square[0]][destination_square[1]] = @board[start_square[0]][start_square[1]]
    temp_pawn = @last_pawn_moved
    update_move_counter(destination_square)
    update_last_pawn(start_square, destination_square)
    en_passant_capture(destination_square, temp_pawn)
    remove_piece(start_square)
  end

  def update_move_counter(destination_square)
    destination = @board[destination_square[0]][destination_square[1]]
    destination.move_counter += 1 if destination.is_a?(Rook) || destination.is_a?(King)
  end

  # Updates the @last_pawn_moved variable
  def update_last_pawn(start, destination)
    @last_pawn_moved = moved_two_squares?(start, destination) ? @board[destination[0]][destination[1]] : nil
  end

  # Checks if a Pawn has moved 2 squares forward
  def moved_two_squares?(start, destination)
    difference = (start[0] - destination[0]).abs
    difference == 2
  end

  # Removes the en passant captured piece
  def en_passant_capture(destination_indx, temp_pawn)
    destination = @board[destination_indx[0]][destination_indx[1]]
    temp_pawn_indx = Matrix[*@board].index(temp_pawn)
    return unless destination.is_a?(Pawn) && destination.en_passant && destination.en_passant.include?(destination_indx)

    remove_piece(temp_pawn_indx)
  end

  # Stores the En Passant move inside the Pawn's valid_moves and en_passant
  def store_en_passant(player, game_end, player_pieces)
    return unless en_passant_available?(player, game_end)

    last_pawn_square = Matrix[*board].index(@last_pawn_moved)
    player_pawns = find_player_pawns(player_pieces, last_pawn_square)

    player_pawns.each do |pawn|
      direction = last_pawn_square[1] - pawn[:current_square][1]
      new_move = create_en_passant_move(player, pawn[:current_square], direction)
      pawn[:piece].en_passant = new_move
      pawn[:piece].valid_moves.push(new_move) if new_move
    end
  end

  # Finds current player's pawns who can make the En Passant move
  def find_player_pawns(player_pieces, last_pawn_square)
    player_pieces.find_all do |obj|
      [-1, 1].any? { |next_col| obj[:piece] == @board[last_pawn_square[0]][last_pawn_square[1] + next_col] }
    end
  end

  # Creates the diagonal En Passant move
  def create_en_passant_move(player, square, direction)
    row_offset = (player.color == :blue ? 1 : -1)
    [[square[0] + row_offset, square[1] + direction]]
  end

  # Checks if En passant is available for the current player
  def en_passant_available?(player, game_end)
    row = player.color == :blue ? 4 : 3
    player_pawns = game_end.find_player_pieces(player.color).find_all do |obj|
      obj[:piece].is_a?(Pawn) && obj[:current_square][0] == row
    end
    return false if player_pawns.empty? || @last_pawn_moved.nil?

    adjacent_en_passant?(player_pawns, row, -1) or
      adjacent_en_passant?(player_pawns, row, 1)
  end

  # Checks for En Passant on a given direction (Left or Right)
  def adjacent_en_passant?(player_pawns, row, next_col)
    player_pawns.each do |pawn|
      next_sq = @board[row][pawn[:current_square][1] + next_col]
      return true if next_sq == @last_pawn_moved
    end
    false
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
    store_en_passant(player, game_end, pieces)
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
