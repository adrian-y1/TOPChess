# frozen_string_literal: true

require 'colorize'

# Module that handles all game information such as errors, instructions etc
module GameInfo
  def position_info(player)
    "\nPlayer #{player.color.to_s.capitalize.bold}, please enter the position of the piece you want to move (e.g. a8):".colorize(player.color)
  end

  def position_error
    "\n#{'Invalid input!'.bold} Please choose from the list of available pieces:".light_red
  end

  def pieces_info(piece_coordinates)
    "#{"Available Pieces (#{piece_coordinates.split(' ').length})".bold} -> #{piece_coordinates.to_s.bold}"
  end

  def move_info(player, piece_position)
    "\nPlayer #{player.color.to_s.capitalize.bold}, please enter the position where you want your #{piece_position.to_s.bold} piece to move:".colorize(player.color)
  end

  def piece_moves_info(piece_moves_coordinates)
    "#{'Available Moves'.bold} -> #{piece_moves_coordinates.to_s.bold}"
  end

  def move_error
    "\n#{'Invalid Input!'.bold} Please choose from the list of available piece moves:".light_red
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
end
