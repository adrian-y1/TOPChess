# frozen_string_literal: true

class King
  attr_reader :color, :colored_symbol

  def initialize(color)
    @symbol = " \u265A "
    @color = color
    @colored_symbol = @symbol.colorize(color: @color)
  end
end
