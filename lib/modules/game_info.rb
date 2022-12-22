# frozen_string_literal: true

require 'colorize'

# Module that handles all game information such as errors, instructions etc
module GameInfo

  def intro
    "\n\n\nWELCOME TO CHESS".bold.green
  end

  def game_rules
    <<~HERODOC
    \n#{"Game Instructions:".bold.yellow}
    #{"[1]".bold.cyan} #{"Player".bold.green} #{"Red".red} #{"&".bold.green} #{"Blue".blue} #{"take turns.".bold.green} #{"Red".red} #{"starts".bold.green}
    #{"[2]".bold.cyan} #{"Player must first enter the coordinates of the piece they want to move (e.g. a2)".bold.green}
    #{"[3]".bold.cyan} #{"The Player will then be asked to enter the coordinates of where they want their chosen piece to move (e.g. a4)".bold.green}
    #{"[4]".bold.cyan} #{"When Promotion is available, a prompt will be given to choose a promotion piece".bold.green}
    #{"[5]".bold.cyan} #{"Castling & En Passant's legal moves will be added directly to their corresponding pieces(s)".bold.green}
    #{"[6]".bold.cyan} #{"There are currently 2 ways for the game to end:".bold.green} #{"Stalemate (draw)".bold.yellow} #{"or".bold.green} #{"Checkmate (win)".bold.green}

    #{"Game Features:".bold.light_yellow}
    #{"[1]".bold.cyan} #{"Castling".bold.green}
    #{"[2]".bold.cyan} #{"Check, Checkmate & Stalemate".bold.green}
    #{"[3]".bold.cyan} #{"En Passant".bold.green}
    #{"[4]".bold.cyan} #{"Promotion".bold.green}
    #{"[5]".bold.cyan} #{"Save Game".bold.green}
    #{"[6]".bold.cyan} #{"Load Saved Game".bold.green}
    #{"[7]".bold.cyan} #{"Captured Pieces".bold.green}

    HERODOC
  end

  def game_rules_input_info
    "Enter".light_yellow + " [Q] ".bold.cyan + "to go back:".light_yellow
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
    puts "\nEnter one of the following options to begin:".bold.light_yellow
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

  def clear_screen
    system 'clear'
  end
end
