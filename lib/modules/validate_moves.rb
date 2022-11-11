# frozen_string_literal: true

module ValidateMoves
  def occupied_by_opponent?(board_square)
    board_square != ' ' && board_square.color != @color
  end

  def occupied_by_own_self?(board_square)
    board_square != ' ' && board_square.color == @color
  end
end