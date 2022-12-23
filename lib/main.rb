# frozen_string_literal: true

require_relative './board'
require_relative './end_game_manager'
require_relative './game'
require 'colorize'

board = Board.new
end_game_manager = EndGameManager.new(board)
game = Game.new(board, end_game_manager)
game.launch_game
