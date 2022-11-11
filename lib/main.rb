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

game_board = Board.new
# BoardSetup.new(game_board.board)

player1 = Player.new(:blue)
player2 = Player.new(:red)

game_board.board[5][1] = Knight.new(:red)
game_board.board[4][3] = King.new(:blue)

p game_board.board[5][1].create_all_moves([5, 1])
p game_board.king_in_check?(player1)
game_board.display