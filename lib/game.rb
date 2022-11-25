#frozen_string_literal: true

require_relative './game_pieces/bishop'
require_relative './game_pieces/rook'
require_relative './game_pieces/pawn'
require_relative './game_pieces/queen'
require_relative './game_pieces/king'
require_relative './game_pieces/knight'
require_relative './board_setup'
require_relative './board'
require_relative './player'
require 'colorize'

# contains everything needed to setup the game
class Game
  attr_reader :board

  def initialize(board = Board.new)
    @board = board
  end
end

game = Game.new
game.board.setup_board
game.board.display