require_relative './game_pieces/bishop'
require_relative './game_pieces/rook'
require_relative './game_pieces/pawn'
require_relative './game_pieces/queen'
require_relative './game_pieces/king'
require_relative './game_pieces/knight'
require_relative './board'
require_relative './board_setup'
require_relative './player'
require_relative './end_game_manager'
require 'colorize'

board = Board.new

player1 = Player.new(:blue)
player2 = Player.new(:red)
