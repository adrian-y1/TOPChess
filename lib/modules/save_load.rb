# frozen_string_literal: true

require_relative '../modules/game_info'
require 'yaml'

# Module that deals with saving and loading the game
module SaveLoad
  include GameInfo

  def save_game?(user_input)
    user_input.downcase == 'save'
  end

  def save_game(game, user_input)
    return unless save_game?(user_input)

    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    
    filename = get_filename

    File.open("saved_games/#{filename}.yml", 'w') do |f|
      YAML.dump(game, f)
    end
  end

  def load_game
    filename = get_load_filename
    permitted_classes = [Symbol, Game, Board, BoardSetup, Rook, Pawn, Bishop, Queen, King, Knight,
                         EndGameManager, GameInfo, ValidateMoves, Player, SaveLoad]
    YAML.safe_load(File.read("saved_games/#{filename}"), permitted_classes: permitted_classes, aliases: true)
  end

  def get_filename
    puts get_filename_info
    saved_games = Dir.glob('saved_games/**/*').select { |f| File.file?(f) }
    puts load_files(saved_games.map { |f| File.basename(f) }.join(', ')) unless saved_games.empty?
    loop do
      user_input = gets.strip
      filename = verify_filename(user_input)
      return filename if filename

      puts get_filename_error
    end
  end

  def get_load_filename
    puts get_load_game_info
    saved_games = Dir.glob('saved_games/**/*').select { |f| File.file?(f) }
    puts load_files(saved_games.map { |f| File.basename(f) }.join(', ')) unless saved_games.empty?

    loop do
      user_input = gets.strip
      return user_input if verify_loaded_filename(user_input)

      puts get_filename_error
    end
  end

  def verify_filename(filename)
    filename if filename.length.between?(1, 10) && !filename.include?('.') && !File.exist?("saved_games/#{filename}.yml")
  end

  def verify_loaded_filename(filename)
    filename if filename.length.between?(1, 10) && File.exist?("saved_games/#{filename}")
  end
end
