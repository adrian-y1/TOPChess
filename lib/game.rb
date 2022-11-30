# frozen_string_literal: true

require_relative './game_pieces/bishop'
require_relative './game_pieces/rook'
require_relative './game_pieces/pawn'
require_relative './game_pieces/queen'
require_relative './game_pieces/king'
require_relative './game_pieces/knight'
require_relative './board_setup'
require_relative './board'
require_relative './player'
require_relative './end_of_game'
require_relative './modules/game_info'
require 'colorize'

# contains everything needed to setup the game
class Game
  attr_reader :board, :blue_player, :red_player

  include GameInfo

  def initialize(board, end_of_game)
    @board = board
    @end_of_game = end_of_game
  end

  def get_piece_position(player)
    piece_coordinates = @board.find_available_piece_coordinates(player, @end_of_game)
    puts position_info(player)
    puts "Available pieces -> #{piece_coordinates}"
    loop do 
      user_input = gets.chomp
      @piece_position = verify_piece_position(user_input, piece_coordinates)
      return @piece_position if @piece_position

      puts position_error
    end
  end

  def verify_piece_position(user_input, piece_coordinates)
    user_input if user_input.length == 2 && piece_coordinates.include?(user_input)
  end

  def setup_players
    @blue_player = Player.new(:blue)
    @red_player = Player.new(:red)
    @current_player = @blue_player
  end
end

board = Board.new
board.setup_board
board.move('d1', 'b5')
end_of_game = EndGame.new(board)
game = Game.new(board, end_of_game)
game.setup_players
game.get_piece_position(game.red_player)
game.board.display
