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
#BoardSetup.new(board.board)

player1 = Player.new(:blue)
player2 = Player.new(:red)
board.board[0][0] = King.new(:blue)
board.board[1][1] = Queen.new(:red)
board.board[2][2] = Bishop.new(:red)
end_game = EndOfGame.new(board)

p end_game.checkmate?(player1)

board.display
