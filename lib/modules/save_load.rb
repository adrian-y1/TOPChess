# frozen_string_literal: true

require_relative '../game_info'
require 'yaml'

# Module that deals with saving and loading the game
module SaveLoad
  include GameInfo

  def save_game?(user_input)
    user_input.downcase == 'save'
  end

  def save_game(game, user_input)
    return unless save_game?(user_input)

    # Create saved_games directiory if it doesn't exist
    Dir.mkdir('saved_games') unless Dir.exists?('saved_games')

    # Get filename from user
    filename = get_filename

    File.open("saved_games/#{filename}.yml", "w") do |f|
      YAML.dump(game, f)
    end
  end

  def get_filename
    puts get_filename_info
    loop do
      user_input = gets.strip
      filename = verify_filename(user_input)
      return filename if filename

      puts get_filename_error
    end
  end

  def verify_filename(filename)
    filename if filename.length.between?(1, 10)
  end
end