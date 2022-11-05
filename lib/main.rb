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
player2 = Player.new(:red)

board_setup.rook_setup(Rook.new(:blue), Rook.new(:red), game_board.board)
board_setup.knight_setup(Knight.new(:blue), Knight.new(:red), game_board.board)
board_setup.bishop_setup(Bishop.new(:blue), Bishop.new(:red), game_board.board)
board_setup.queen_setup(Queen.new(:blue), Queen.new(:red), game_board.board)
board_setup.king_setup(King.new(:blue), King.new(:red), game_board.board)
board_setup.pawn_setup(game_board.board)


if game_board.free?('b6', player1)
    game_board.move('b8', 'b6')
end
# game_board.display

new_knight = Knight.new(:blue)
temp_board = Board.new
temp_board.board[3][7] = new_knight

moves = new_knight.find_valid_moves([3, 7])
moves.each {|i| temp_board.board[i[0]][i[1]] = new_knight}

temp_board.display
p moves