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

square = [3, 4]
game_board.board[3][4] = Bishop.new(:blue)
game_board.board[5][6] = Bishop.new(:blue)
moves = game_board.board[square[0]][square[1]].create_diagonal_moves(square, [1, 1], game_board)
moves.each { |m| game_board.board[m[0]][m[1]] = Bishop.new(:red) }
p moves
game_board.display
