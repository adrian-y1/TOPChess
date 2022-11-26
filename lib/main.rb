require_relative './game_pieces/bishop'
require_relative './game_pieces/rook'
require_relative './game_pieces/pawn'
require_relative './game_pieces/queen'
require_relative './game_pieces/king'
require_relative './game_pieces/knight'
require_relative './board'
require_relative './board_setup'
require_relative './player'
require_relative './end_of_game'
require 'colorize'

board = Board.new


player1 = Player.new(:blue)
player2 = Player.new(:red)

board.setup_board
p board.square_index_to_coordinates([7, 7])
board.display
