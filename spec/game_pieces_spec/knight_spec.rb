# frozen_string_literal: true

require_relative '../../lib/game_pieces/knight'
require 'colorize'

describe Knight do
  subject(:knight) { described_class.new(:blue) }

  describe '#create_possible_moves' do
    context 'when Knight is at square [3, 4]' do
      it 'returns an array of possible squares the Knight can move to' do
        square = [3, 4]
        possible_moves = [[1, 3], [1, 5], [2, 6], [2, 2], [4, 6], [4, 2], [5, 5], [5, 3]]
        create = knight.create_possible_moves(square)
        expect(create).to eq(possible_moves)
      end
    end

    context 'when the Knight is at square [0, 0]' do
      it 'returns an array of possible squares to move to, both in-bound and out-of-bounds' do
        square = [0, 0]
        possible_moves = [[-2, -1], [-2, 1], [-1, 2], [-1, -2], [1, 2], [1, -2], [2, 1], [2, -1]]
        create = knight.create_possible_moves(square)
        expect(create).to eq(possible_moves)
      end
    end
  end

  describe '#find_valid_moves' do
    context 'when the Knight is at square [0, 0]' do
      before do
        possible_moves = [[-2, -1], [-2, 1], [-1, 2], [-1, -2], [1, 2], [1, -2], [2, 1], [2, -1]]
        allow(knight).to receive(:create_possible_moves).with([0, 0]).and_return(possible_moves)
      end

      it 'returns an array of all the valid squares the Knight can move to' do
        square = [0, 0]
        valid_moves = [[1, 2], [2, 1]]
        find_moves = knight.find_valid_moves(square)
        expect(find_moves).to eq(valid_moves)
      end
    end
  end
end
