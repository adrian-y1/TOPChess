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
board.board[3][3] = King.new(:blue)
board.board[2][2] = Rook.new(:blue)
board.board[7][2] = Rook.new(:blue)
board.board[3][6] = Rook.new(:red)
board.board[3][2] = Rook.new(:red)
board.board[6][2] = Rook.new(:red)
board.board[5][1] = Queen.new(:red)

p board.interception_available?(player1)

board.display
