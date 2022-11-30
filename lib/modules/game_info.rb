# frozen_string_literal: true

require 'colorize'

# Module that handles all game information such as errors, instructions etc
module GameInfo
  def position_info(player)
    "Player #{player.color}, please enter the position of the piece you want to move (e.g. a8):".colorize(player.color)
  end

  def position_error
    "Invalid input! Please choose from the list of available pieces:".light_red
  end
end