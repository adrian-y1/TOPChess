require_relative './game_pieces/bishop.rb'
require_relative './game_pieces/rook.rb'
require_relative './game_pieces/pawn.rb'
require_relative './game_pieces/queen.rb'
require_relative './game_pieces/king.rb'
require_relative './game_pieces/knight.rb'
require_relative './board.rb'
require 'colorize'

def rook_setup(blue_rook, red_rook, board)
    board[0][0] = blue_rook
    board[0][7] = blue_rook
    board[7][0] = red_rook
    board[7][7] = red_rook
end

def knight_setup(blue_knight, red_knight, board)
    board[0][1] = blue_knight
    board[0][6] = blue_knight
    board[7][1] = red_knight
    board[7][6] = red_knight
end

def bishop_setup(blue_bishop, red_bishop, board)
    board[0][2] = blue_bishop
    board[0][5] = blue_bishop
    board[7][2] = red_bishop
    board[7][5] = red_bishop
end

def queen_setup(blue_queen, red_queen, board)
    board[0][3] = blue_queen
    board[7][3] = red_queen
end

def king_setup(blue_king, red_king, board)
    board[0][4] = blue_king
    board[7][4] = red_king
end

def pawn_setup(board)
    (0..7).each {|i| board[1][i] = Pawn.new(:blue) }
    (0..7).each {|i| board[6][i] = Pawn.new(:red) }
end

game_board = Board.new

rook_setup(Rook.new(:blue), Rook.new(:red), game_board.board)
knight_setup(Knight.new(:blue), Knight.new(:red), game_board.board)
bishop_setup(Bishop.new(:blue), Bishop.new(:red), game_board.board)
queen_setup(Queen.new(:blue), Queen.new(:red), game_board.board)
king_setup(King.new(:blue), King.new(:red), game_board.board)
pawn_setup(game_board.board)

game_board.display