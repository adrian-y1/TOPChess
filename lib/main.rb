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
board.board[0][4] = Rook.new(:blue)
board.board[3][3] = Queen.new(:red)
board.board[2][1] = Rook.new(:red)

#board.move('e8', 'd2')
p board.checkmate?(player1)
p board.king_in_check?(player1)
p board.move_to_safe_position?(player1)
p board.interception_available?(player1)
p board.checking_piece_capturable?(player1)

board.display
