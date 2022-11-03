# frozen_string_literal: true

class Bishop 
    attr_reader :color, :colored_symbol

    def initialize(color)
        @symbol = " \u265D "
        @color = color
        @colored_symbol = @symbol.colorize(:color => @color)
    end
end