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
require_relative './end_game_manager'
require_relative './modules/game_info'
require_relative './modules/save_load'
require 'colorize'

# contains everything needed to setup the game
class Game
  attr_reader :board, :blue_player, :red_player

  include SaveLoad
  include GameInfo

  def initialize(board, end_game_manager)
    @board = board
    @end_game_manager = end_game_manager
  end

  def launch_game
    choice = get_choice
    setup_players
    if choice == '1'
      play_game
    elsif choice == '2'
      load_game.play_game
    end
  end

  def play_game
    # puts game_rules
    @board.setup_board
    @board.display
    loop do
      play_turn(@current_player)
      return if game_end?(@current_player)

      switch_turn
    end
  end

  def play_turn(player)
    piece_position = get_piece_position(player)
    destination = get_piece_move(player)
    @board.move(piece_position, destination)
    promotion(player)
    @board.display
    p @board.removed_pieces
  end

  def get_choice
    puts choice_info
    loop do
      choice = gets.strip
      return choice if verify_choice(choice)

      puts choice_error
    end
  end

  def get_piece_position(player)
    piece_coordinates = @board.find_available_piece_coordinates(player, @end_game_manager)
    puts position_info(player)
    puts pieces_info(player, piece_coordinates)
    loop do
      user_input = gets.chomp
      @piece_position = verify_position(user_input, piece_coordinates)
      exit if save_game(self, user_input)
      return @piece_position if @piece_position

      puts position_error
    end
  end

  def get_piece_move(player)
    piece_move_coordinates = @board.find_valid_piece_move_coordinates(@piece_position)
    puts move_info(player, @piece_position)
    puts piece_moves_info(player, piece_move_coordinates)
    loop do
      user_input = gets.chomp
      @move_position = verify_position(user_input, piece_move_coordinates)
      exit if save_game(self, user_input)
      return @move_position if @move_position

      puts move_error
    end
  end

  def get_promotion_piece(player)
    promotable_pawn = @board.find_promotable_pawn(player)
    promotable_pawn_coordinates = @board.square_index_to_coordinates(promotable_pawn)
    puts promotion_info(player, promotable_pawn_coordinates)
    loop do
      user_input = gets.chomp
      promotion_piece = verify_promotion_piece(user_input)
      return promotion_piece if promotion_piece

      puts promotion_error
    end
  end

  def verify_promotion_piece(user_input)
    pieces = %w[Queen Rook Bishop Knight]
    user_input if pieces.include?(user_input.capitalize)
  end

  def verify_position(user_input, piece_coordinates)
    user_input.downcase!
    user_input if user_input.length == 2 && piece_coordinates.include?(user_input)
  end

  def verify_choice(choice)
    choice if %w[1 2].include?(choice)
  end

  def setup_players
    @blue_player = Player.new(:blue)
    @red_player = Player.new(:red)
    @current_player = @red_player
  end

  def promotion(player)
    return unless @board.promotion_available?(player)

    chosen_piece = get_promotion_piece(player)
    @board.make_promotion(player, chosen_piece)
  end

  def switch_turn
    @current_player = @current_player == @blue_player ? @red_player : @blue_player
  end

  def game_won?(opponent)
    return false unless @end_game_manager.checkmate?(opponent)

    puts checkmate_info(opponent)
    true
  end

  def game_draw?(opponent)
    return false unless @end_game_manager.stalemate?(opponent)

    puts stalemate_info
    true
  end

  def game_end?(player)
    opponent = player == @blue_player ? @red_player : @blue_player
    puts in_check_info(player, opponent) if @end_game_manager.king_in_check?(opponent)
    game_draw?(opponent) || game_won?(opponent)
  end
end

board = Board.new
end_game_manager = EndGameManager.new(board)
game = Game.new(board, end_game_manager)
game.launch_game
