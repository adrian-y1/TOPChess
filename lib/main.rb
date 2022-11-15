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
# BoardSetup.new(board.board)

player1 = Player.new(:blue)
player2 = Player.new(:red)
square = [2, 2]
board.board[square[0]][square[1]] = Pawn.new(:blue)

moves = board.board[square[0]][square[1]].two_square_move(square, board)
moves.each { |m| board.board[m[0]][m[1]] = Pawn.new(:red) }
p moves

board.display
