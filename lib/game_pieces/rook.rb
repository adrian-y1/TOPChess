# frozen_string_literal: true

class Rook
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265C "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
  end
end
