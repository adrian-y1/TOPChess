# frozen_string_literal: true

require_relative './game_pieces/bishop'
require_relative './game_pieces/king'
require_relative './game_pieces/knight'
require_relative './game_pieces/pawn'
require_relative './game_pieces/queen'
require_relative './game_pieces/rook'
require_relative './modules/game_info'
require_relative './modules/save_load'
require_relative './modules/validate_moves'
require_relative './board_setup'
require_relative './board'
require_relative './end_game_manager'
require_relative './player'
require_relative './game'
require 'colorize'

board = Board.new
end_game_manager = EndGameManager.new(board)
game = Game.new(board, end_game_manager)
game.launch_game
