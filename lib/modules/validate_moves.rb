# frozen_string_literal: true

module ValidateMoves
  def occupied_by_opponent?(board_square, color)
    board_square != ' ' && board_square.color != color
  end

  def occupied_by_own_self?(board_square, color)
    board_square != ' ' && board_square.color == color
  end

  def update_movement(moves)
    unless moves[0].zero?
      moves[0].positive? ? moves[0] += 1 : moves[0] -= 1
    end
    return if moves[1].zero?

    moves[1].positive? ? moves[1] += 1 : moves[1] -= 1
  end

  def inside_board?(square)
    square[0].between?(0, 7) && square[1].between?(0, 7)
  end
end
