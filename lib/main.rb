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
board.board[0][1] = King.new(:blue)
board.board[1][4] = Rook.new(:blue)
board.board[3][4] = Queen.new(:red)
board.board[2][0] = Knight.new(:red)

#board.move('e8', 'd2')
p board.find_checking_piece(player1)

board.display
