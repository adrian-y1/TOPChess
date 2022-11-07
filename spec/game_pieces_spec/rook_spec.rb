# frozen_string_literal: true

require_relative '../../lib/game_pieces/rook'
require 'colorize'

describe Rook do
  subject(:rook) { described_class.new(:blue) }

  describe '#create_row_moves' do
    context 'when the column of a square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [3, 10]
        left_move = [0, -1]
        create_moves = rook.create_row_moves(square, left_move)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [5, 6] with the left movement' do
      it 'returns 6 valid squares the rook can move to on the left side' do
        square = [5, 6]
        left_move = [0, -1]
        valid_moves = [[5, 5], [5, 4], [5, 3], [5, 2], [5, 1], [5, 0]]
        create_moves = rook.create_row_moves(square, left_move)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 6] with the right movement' do
      it "returns 1 valid square the rook can move to it's right" do
        square = [5, 6]
        right_move = [0, 1]
        valid_moves = [[5, 7]]
        create_moves = rook.create_row_moves(square, right_move)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end

  describe '#create_column_moves' do
    context 'when the row of a square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [9, 1]
        top_move = [-1, 0]
        create_moves = rook.create_column_moves(square, top_move)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [3, 3] with the top movement' do
      it "returns 3 valid squares the rook can move to it's top side" do
        square = [3, 3]
        top_move = [-1, 0]
        valid_moves = [[2, 3], [1, 3], [0, 3]]
        create_moves = rook.create_column_moves(square, top_move)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 3] with the bottom movement' do
      it "returns 4 valid squares the rook can move to it's bottom side" do
        square = [3, 3]
        bottom_move = [1, 0]
        valid_moves = [[4, 3], [5, 3], [6, 3], [7, 3]]
        create_moves = rook.create_column_moves(square, bottom_move)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end
end
