# frozen_string_literal: true

class Queen 
    attr_reader :color, :colored_symbol

    def initialize(color)
        @symbol = " \u265B "
        @color = color
        @colored_symbol = @symbol.colorize(:color => @color)
    end
end