# frozen_string_literal: true

require_relative '../../lib/game_pieces/king.rb'
require 'colorize'

describe King do
  subject(:king) { described_class.new(:blue) }
  describe '#create_all_moves' do
    context 'when given an out-of-bound square (not between 0 & 7)' do
      it 'stops loop' do
        square = [9, 9]
        create_moves = king.create_all_moves(square)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [2, 3]' do
      it 'returns all valid moves the King can make in all the directions' do
        square = [2, 3]
        valid_moves = [[1, 3], [1, 2], [2, 2], [3, 2], [3, 3], [3, 4], [2, 4], [1, 4]]
        create_moves = king.create_all_moves(square)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 7]' do
      it 'returns all valid moves the King can make any direction' do
        square = [5, 7]
        valid_moves = [[4, 7], [4, 6], [5, 6], [6, 6], [6, 7]]
        create_moves = king.create_all_moves(square)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end
end