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
#BoardSetup.new(board.board)

player1 = Player.new(:blue)
player2 = Player.new(:red)
board.board[2][3] = King.new(:blue)
board.board[0][6] = Knight.new(:blue)
board.board[6][7] = Bishop.new(:red)

#board.move('e8', 'd2')
p board.interception_available?(player1)

board.display
