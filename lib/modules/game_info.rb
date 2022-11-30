# frozen_string_literal: true

require 'colorize'

# Module that handles all game information such as errors, instructions etc
module GameInfo
  def position_info(player)
    "\nPlayer #{player.color}, please enter the position of the piece you want to move (e.g. a8):".colorize(player.color)
  end

  def position_error
    "\nInvalid input! Please choose from the list of available pieces:".light_red
  end

  def pieces_info(piece_coordinates)
    "Available Pieces -> #{piece_coordinates}"
  end

  def move_info(player, piece_position)
    "\nPlayer #{player.color}, please enter the position where you want your #{piece_position} piece to move:".colorize(player.color)
  end

  def piece_moves_info(piece_moves_coordinates)
    "Available Moves -> #{piece_moves_coordinates}"
  end

  def move_error
    "\nInvalid Input! Please choose from the list of available piece moves:".light_red
  end
end