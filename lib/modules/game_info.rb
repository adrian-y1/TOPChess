# frozen_string_literal: true

require 'colorize'

# Module that handles all game information such as errors, instructions etc
module GameInfo
  def intro
    "\n\n\nWELCOME TO CHESS".bold.green
  end

  def game_rules
    <<~HERODOC
      \n#{'Game Instructions:'.bold.yellow}
      #{'[1]'.bold.cyan} #{'Player'.bold.green} #{'Red'.bold.red} #{'&'.bold.green} #{'Blue'.bold.blue} #{'take turns.'.bold.green} #{'Red'.bold.red} #{'starts'.bold.green}
      #{'[2]'.bold.cyan} #{'Player must first enter the coordinates of the piece they want to move (e.g. a2)'.bold.green}
      #{'[3]'.bold.cyan} #{'The Player will then be asked to enter the coordinates of where they want their chosen piece to move (e.g. a4)'.bold.green}
      #{'[4]'.bold.cyan} #{'When Promotion is available, a prompt will be given to choose a promotion piece'.bold.green}
      #{'[5]'.bold.cyan} #{"Castling & En Passant's legal moves will be added directly to their corresponding pieces(s)".bold.green}
      #{'[6]'.bold.cyan} #{'There are currently 3 ways for the game to end:'.bold.green} #{'Stalemate (draw)'.bold.yellow}#{','.bold.green} #{'Checkmate & Resignation (win)'.bold.cyan}
      #{'[7]'.bold.cyan} #{'To save a file, type'.bold.green} #{'[save]'.bold.cyan} #{"when picking a piece's coordinates".bold.green}
      #{'[8]'.bold.cyan} #{'To forfeit a game, type'.bold.green} #{'[forfeit]'.bold.cyan} #{"when picking a piece's coordinates".bold.green}

      #{'Game Features:'.bold.light_yellow}
      #{'[1]'.bold.cyan} #{'Castling'.bold.green}
      #{'[2]'.bold.cyan} #{'Check'.bold.green}
      #{'[3]'.bold.cyan} #{'Checkmate, Resignation & Stalemate'.bold.green}
      #{'[4]'.bold.cyan} #{'En Passant'.bold.green}
      #{'[5]'.bold.cyan} #{'Promotion'.bold.green}
      #{'[6]'.bold.cyan} #{'Save Game'.bold.green}
      #{'[7]'.bold.cyan} #{'Load Saved Game'.bold.green}
      #{'[8]'.bold.cyan} #{'Captured Pieces'.bold.green}

    HERODOC
  end

  def game_rules_input_info
    'Enter'.light_yellow + ' [Q] '.bold.cyan + 'to go back:'.light_yellow
  end

  def game_rules_input_error
    'Invalid Input! Enter'.light_red + ' [Q] '.cyan + 'to go back:'.light_red
  end

  def position_info(player)
    "\nEnter the coordinates of the piece you want to move:".bold.colorize(player.color)
  end

  def position_error
    "\n#{'Invalid input!'.bold} Please choose from the list of available pieces:".light_red
  end

  def pieces_info(player, piece_coordinates)
    "#{"Available Pieces (#{piece_coordinates.split(' ').length})".bold} -> #{piece_coordinates}".colorize(player.color)
  end

  def move_info(player, piece_position)
    "\nEnter the coordinates where you want your #{piece_position.to_s.bold} piece to move:".bold.colorize(player.color)
  end

  def piece_moves_info(player, piece_moves_coordinates)
    "#{"Available Moves (#{piece_moves_coordinates.split(' ').length})".bold} -> #{piece_moves_coordinates}".colorize(player.color)
  end

  def move_error
    "\n#{'Invalid Input!'.bold} Please choose from the list of piece's available moves:".light_red
  end

  def promotion_info(_player, pawn_coordinates)
    puts "\nYour Pawn at location #{pawn_coordinates.to_s.bold} has reached Promotion.".yellow
    <<~HERODOC

      #{"Please choose one of the following pieces to promote your Pawn to:\n".bold.yellow}#{'Queen, Rook, Bishop, Knight'.yellow}
    HERODOC
  end

  def promotion_error
    "\n#{'Invalid Input!'.bold} Please enter one of the above listed pieces:".light_red
  end

  def checkmate_info(opponent)
    player = opponent.color == :red ? :blue : :red
    "\n#{'Congratulations, Player'.bold.green} #{player.to_s.capitalize.bold.colorize(player)}#{'! You have checkmated your opponent.'.bold.green}"
  end

  def stalemate_info
    'Stalemate! The game has ended in a draw.'.light_yellow
  end

  def in_check_info(player, opponent)
    "\n#{'Check!'.bold} Player #{player.color.to_s.capitalize.bold} has put Player #{opponent.color.to_s.capitalize.bold}'s King check.".yellow
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
    print "#{'[1]'.cyan} #{'Start New Game'.light_yellow}\n#{'[2]'.cyan} #{'Load Saved Game'.light_yellow}\n"
    "#{'[3]'.cyan} #{'Game Instructions & Structure'.light_yellow}"
  end

  def choice_error
    "\nInvalid Input! Please choose one of the above options:".light_red
  end

  def saving_loading(action)
    puts "#{action} Game...\n\n"
    sleep(1)
    return if action == 'Loading'

    puts 'Exiting Program...'
    sleep(0.5)
  end

  def captured_pieces_info(captured_pieces)
    <<~HERODOC
      #{'Captured Pieces'.bold.magenta}

      #{'Player Blue ->'.bold.blue}#{captured_pieces.select { |h| h[:color] == :red }.map { |h| h[:symbol] }.join('').bold.red}

      #{'Player Red  ->'.bold.red}#{captured_pieces.select { |h| h[:color] == :blue }.map { |h| h[:symbol] }.join('').bold.blue}

    HERODOC
  end

  def forfeit_win(player)
    "\n#{'Congratulations, Player'.bold.green} #{player.to_s.capitalize.bold.colorize(player)}#{'! Your opponent has forfeited the match.'.bold.green}"
  end

  def clear_screen
    system 'clear'
  end

  def empty_dir_info
    "\nThere are 0 saved files!\n".bold.cyan
  end

  def player_turn_info(current_player)
    "\n#{current_player.color.to_s.capitalize}'s turn!".bold.colorize(current_player.color)
  end
end
