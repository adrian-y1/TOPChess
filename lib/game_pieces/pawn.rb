# frozen_string_literal: true

class Pawn
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265F "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
  end
end
