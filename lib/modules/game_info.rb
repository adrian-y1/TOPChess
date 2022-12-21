# frozen_string_literal: true

require 'colorize'

# Module that handles all game information such as errors, instructions etc
module GameInfo

  def intro
    "\nWELCOME TO CHESS".bold.cyan
  end

  def game_rules
    <<~HERODOC
    \nGame Instructions:
    #{"[1]".cyan} Player #{"Red".red} & #{"Blue".blue} take turns. #{"Red".red} starts.
    #{"[2]".cyan} The current player must first enter the coordinates of the piece they want to move (e.g. a2)
    #{"[3]".cyan} The current player will then be asked to enter the coordinates of where they want their chosen piece to move (e.g. a4)
    #{"[4]".cyan} When Promotion is available, you will be asked to enter the name of the piece you want to promote to
    #{"[5]".cyan} Castling & En Passant's legal moves will be added directly to their corresponding pieces(s)
    #{"[6]".cyan} There are currently 2 ways for the game to end: Stalemate (draw) or Checkmate (win)
    HERODOC
  end

  def game_rules_input_info
    "Enter".light_yellow + " [Q] ".cyan + "to go back:".light_yellow
  end

  def game_rules_input_error
    "Invalid Input! Enter".light_red + " [Q] ".cyan + "to go back:".light_red
  end

  def position_info(player)
    "\nPlayer #{player.color.to_s.capitalize.bold}, enter the coordinates of the piece you want to move:".colorize(player.color)
  end

  def position_error
    "\n#{'Invalid input!'.bold} Please choose from the list of available pieces:".light_red
  end

  def pieces_info(player, piece_coordinates)
    "#{"Available Pieces (#{piece_coordinates.split(' ').length})".bold} -> #{piece_coordinates.to_s.bold}".colorize(player.color)
  end

  def move_info(player, piece_position)
    "\nPlayer #{player.color.to_s.capitalize.bold}, enter the coordinates where you want your #{piece_position.to_s.bold} piece to move:".colorize(player.color)
  end

  def piece_moves_info(player, piece_moves_coordinates)
    "#{'Available Moves'.bold} -> #{piece_moves_coordinates.to_s.bold}".colorize(player.color)
  end

  def move_error
    "\n#{'Invalid Input!'.bold} Please choose from the list of piece's available moves:".light_red
  end

  def promotion_info(player, pawn_coordinates)
    puts "\nPlayer #{player.color.to_s.capitalize.bold}, your Pawn at location #{pawn_coordinates.to_s.bold} has reached Promotion.".yellow
    <<~HERODOC

      #{"Please choose one of the following pieces to promote your Pawn to: \n#{'Queen, Rook, Bishop, Knight'.bold}".yellow}
    HERODOC
  end

  def promotion_error
    "\n#{'Invalid Input!'.bold} Please enter one of the above listed pieces:".light_red
  end

  def checkmate_info(opponent)
    player = opponent.color == :red ? :blue : :red
    "Congratulations, Player #{player.to_s.capitalize.bold}! You have checkmated your opponent.".green
  end

  def stalemate_info
    'Stalemate! The game has ended in a draw.'.light_yellow
  end

  def in_check_info(player, opponent)
    "#{'Check!'.bold} Player #{player.color.to_s.capitalize.bold} has put Player #{opponent.color.to_s.capitalize.bold}'s King check.".yellow
  end

  def get_filename_info
    "\nEnter a name for the file (max 10 characters):".bold.light_yellow
  end

  def get_filename_error
    "\nInvalid Input!".bold.light_red
  end

  def get_load_game_info
    "\nEnter the full name of the saved game you want to load:".bold.light_yellow
  end

  def load_files(files)
    "All Saved Games (#{files.split(' ').length}) -> #{files}".light_yellow
  end

  def choice_info
    puts 'Enter one of the following options to begin:'.bold.light_yellow
    print "#{"[1]".cyan} #{"Start New Game".light_yellow}\n#{"[2]".cyan} #{"Load Saved Game".light_yellow}\n"
    "#{"[3]".cyan} #{"Game Instructions & Structure".light_yellow}"
  end

  def choice_error
    "\nInvalid Input! Please enter 1 to start a new game or 2 to load a saved game:".light_red
  end
  
  def saving_loading(action)
    puts "#{action} Game...\n\n"
    sleep(1)
    return if action == "Loading"
    puts "Exiting Program..."
    sleep(0.5)
  end

  def captured_pieces_info(captured_pieces)
    <<~HERODOC 
      #{"Captured Pieces".bold.magenta}

      #{"Player Blue ->".bold.blue}#{captured_pieces.select { |h| h[:color] == :red }.map { |h| h[:symbol] }.join('').bold.red}

      #{"Player Red  ->".bold.red}#{captured_pieces.select { |h| h[:color] == :blue }.map { |h| h[:symbol] }.join('').bold.blue}

    HERODOC
  end

end
