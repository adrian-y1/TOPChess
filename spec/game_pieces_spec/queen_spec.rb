# frozen_string_literal: true

require_relative '../../lib/game_pieces/queen.rb'
require 'colorize'

describe Queen do
  subject(:queen) { described_class.new(:blue) }

  describe '#create_diagonal_moves' do
    context 'when the square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [9, 10]
        top_right = [-1, 1]
        create_moves = queen.create_diagonal_moves(square, top_right)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [5, 5] and the top left direction' do
      it "returns 5 valid squares the Queen can move to on it's top left" do
        square = [5, 5]
        top_left = [-1, -1]
        valid_moves = [[4, 4], [3, 3], [2, 2], [1, 1], [0, 0]]
        create_moves = queen.create_diagonal_moves(square, top_left)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] and the top right direction' do
      it "returns 2 valid squares the Queen can move to on it's top right" do
        square = [5, 5]
        top_right = [-1, 1]
        valid_moves = [[4, 6], [3, 7]]
        create_moves = queen.create_diagonal_moves(square, top_right)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] and the bottom left direction' do
      it "returns 2 valid squares the Queen can move to on it's bottom left" do
        square = [5, 5]
        bottom_left = [1, -1]
        valid_moves = [[6, 4], [7, 3]]
        create_moves = queen.create_diagonal_moves(square, bottom_left)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] and the bottom right direction' do
      it "returns 2 valid squares the Queen can move to on it's bottom right" do
        square = [5, 5]
        bottom_right = [1, 1]
        valid_moves = [[6, 6], [7, 7]]
        create_moves = queen.create_diagonal_moves(square, bottom_right)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end

  describe '#create_row_moves' do
    context 'when the column of a square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [7, 10]
        left = [0, -1]
        create_moves = queen.create_row_moves(square, left)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [5, 5] with the left movement' do
      it "returns 5 valid squares the Queen can move to on it's left" do
        square = [5, 5]
        left = [0, -1]
        valid_moves = [[5, 4], [5, 3], [5, 2], [5, 1], [5, 0]]
        create_moves = queen.create_row_moves(square, left)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] with the right movement' do
      it "returns 2 valid squares the Queen can move to on it's right" do
        square = [5, 5]
        right = [0, 1]
        valid_moves = [[5, 6], [5, 7]]
        create_moves = queen.create_row_moves(square, right)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end

  describe '#create_column_moves' do
    context 'when the row of a square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [9, 5]
        top = [-1, 0]
        create_moves = queen.create_column_moves(square, top)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [5, 5] with the top movement' do
      it "returns 5 valid squares the Queen can move to it's top" do
        square = [5, 5]
        top = [-1, 0]
        valid_moves = [[4, 5], [3, 5], [2, 5], [1, 5], [0, 5]]
        create_moves = queen.create_column_moves(square, top)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] with the bottom movement' do
      it "returns 2 valid squares the Queen can move to it's bottom" do
        square = [5, 5]
        bottom = [1, 0]
        valid_moves = [[6, 5], [7, 5]]
        create_moves = queen.create_column_moves(square, bottom)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end
end