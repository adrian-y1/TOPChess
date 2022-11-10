# frozen_string_literal: true

# Class that sets up the game pieces
class BoardSetup
  def initialize(board)
    @board = board
    setup_board
  end

  def setup_board
    @board.each_index do |row|
      case row
      when 0
        create_game_pieces(row, :blue, @board)
      when 7
        create_game_pieces(row, :red, @board)
      end
    end
  end
 
  def create_game_pieces(row, color, board)
    (0..7).each do |column|
      row == 7 ? board[row - 1][column] = Pawn.new(color) : board[row + 1][column] = Pawn.new(color)
      board[row][column] = Rook.new(color) if [0, 7].include?(column)
      board[row][column] = Knight.new(color) if [1, 6].include?(column)
      board[row][column] = Bishop.new(color) if [2, 5].include?(column)
      board[row][column] = Queen.new(color) if column == 3
      board[row][column] = King.new(color) if column == 4
    end
  end
end
