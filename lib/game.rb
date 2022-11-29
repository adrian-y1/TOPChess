# frozen_string_literal: true

require_relative './game_pieces/bishop'
require_relative './game_pieces/rook'
require_relative './game_pieces/pawn'
require_relative './game_pieces/queen'
require_relative './game_pieces/king'
require_relative './game_pieces/knight'
require_relative './board_setup'
require_relative './board'
require_relative './player'
require_relative './end_of_game'
require 'colorize'

# contains everything needed to setup the game
class Game
  attr_reader :board, :blue_player, :red_player

  def initialize(board, end_of_game)
    @board = board
    @end_of_game = end_of_game
  end

  def setup_players
    @blue_player = Player.new(:blue)
    @red_player = Player.new(:red)
    @current_player = @blue_player
  end

  # def find_available_piece_positions(player)
  #   pieces = @end_of_game.find_player_pieces(player.color)
  #   pieces_square = pieces.map { |obj| obj[:current_square] unless obj[:piece].valid_moves.empty? }.compact
  #   pieces_square.map { |square| board.square_index_to_coordinates(square) }.join(', ')
  # end
end

board = Board.new
#board.setup_board
board.board[3][4] = King.new(:blue)

board.board[6][3] = Queen.new(:red)

end_of_game = EndGame.new(board)
game = Game.new(board, end_of_game)
game.setup_players
board.remove_illegal_moves(game.blue_player, end_of_game)
#p end_of_game.king_in_check?(game.blue_player)
# end_of_game.remove_illegal_moves(game.blue_player)
game.board.display