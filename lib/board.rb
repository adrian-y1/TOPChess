# frozen_string_literal: true
require 'colorize'

# Class the defines the board of the game and it's respective methods
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) {' '}}
  end

  def display 
    @board.each_index do |r|
      @board[r].each_index do |c|
        square = @board[r][c] == ' ' ? "#{@board[r][c]}  " : @board[r][c]
        if r.even?
          print c.even? ? square.on_white : square.on_black
        else
          print c.odd? ? square.on_white : square.on_black
        end
      end
      puts "\n"
    end
  end
end

board = Board.new
board.display
