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
board_setup = BoardSetup.new
player1 = Player.new(:blue)

board_setup.rook_setup(Rook.new(:blue), Rook.new(:red), game_board.board)
board_setup.knight_setup(Knight.new(:blue), Knight.new(:red), game_board.board)
board_setup.bishop_setup(Bishop.new(:blue), Bishop.new(:red), game_board.board)
board_setup.queen_setup(Queen.new(:blue), Queen.new(:red), game_board.board)
board_setup.king_setup(King.new(:blue), King.new(:red), game_board.board)
board_setup.pawn_setup(game_board.board)

game_board.move('b8', 'b6') if game_board.free?('b6', player1)
# game_board.display

square = [6, 2]
new_pawn = Pawn.new(:red)
temp_board = Board.new
temp_board.board[square[0]][square[1]] = Pawn.new(:red)

moves = new_pawn.two_square_move([square[0], square[1]])
p moves
moves.each { |i| temp_board.board[i[0]][i[1]] = new_pawn }

temp_board.display
