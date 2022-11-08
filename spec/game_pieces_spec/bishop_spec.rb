# frozen_string_literal: true

require_relative '../../lib/game_pieces/bishop'
require 'colorize'

describe Bishop do
  subject(:bishop) { described_class.new(:blue) }

  describe '#create_diagonal_moves' do
    context 'when the square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [9, 9]
        top_left = [-1, -1]
        create_moves = bishop.create_diagonal_moves(square, top_left)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [3, 4] and the top left movement' do
      it "returns 3 valid squares the Bishop can move to on it's top left" do
        square = [3, 4]
        top_left = [-1, -1]
        valid_moves = [[2, 3], [1, 2], [0, 1]]
        create_moves = bishop.create_diagonal_moves(square, top_left)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 4] and the bottom left movement' do
      it "returns 4 valid squares the Bishop can move to on it's bottom left" do
        square = [3, 4]
        bottom_left = [1, -1]
        valid_moves = [[4, 3], [5, 2], [6, 1], [7, 0]]
        create_moves = bishop.create_diagonal_moves(square, bottom_left)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 4] and the top right movement' do
      it "returns 3 valid squares the Bishop can move to on it's top right" do
        square = [3, 4]
        top_right = [-1, 1]
        valid_moves = [[2, 5], [1, 6], [0, 7]]
        create_moves = bishop.create_diagonal_moves(square, top_right)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 4] and the bottom right movement' do
      it "returns 3 valid squares the Bishop can move to on it's bottom right" do
        square = [3, 4]
        bottom_right = [1, 1]
        valid_moves = [[4, 5], [5, 6], [6, 7]]
        create_moves = bishop.create_diagonal_moves(square, bottom_right)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end
end
