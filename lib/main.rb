require_relative './game_pieces/bishop'
require_relative './game_pieces/rook'
require_relative './game_pieces/pawn'
require_relative './game_pieces/queen'
require_relative './game_pieces/king'
require_relative './game_pieces/knight'
require_relative './board'
require_relative './board_setup'
require_relative './player'
require 'colorize'

board = Board.new
BoardSetup.new(board.board)

player1 = Player.new(:blue)
player2 = Player.new(:red)
board.move('e8', 'b1')
squares = board.find_checking_piece_square(player1)
p squares
board.display
