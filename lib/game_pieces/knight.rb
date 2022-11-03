# frozen_string_literal: true

class Knight 
    attr_reader :color, :colored_symbol

    def initialize(color)
        @symbol = " \u265E "
        @color = color
        @colored_symbol = @symbol.colorize(:color => @color)
    end
end