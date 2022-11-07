# frozen_string_literal: true

class King
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265A "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
    @movement = [[-1, 0], [-1, -1], [0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1]]
    @valid_moves = []
  end

  def create_all_moves(square)
    @movement.each do |move|
      row = square[0] + move[0]
      column = square[1] + move[1]
      @valid_moves.push([row, column]) if row.between?(0, 7) && column.between?(0, 7)
    end
    @valid_moves
  end
end
