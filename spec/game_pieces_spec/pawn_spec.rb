# frozen_string_literal: true

require_relative '../../lib/game_pieces/pawn'
require 'colorize'

describe Pawn do
  subject(:pawn) { described_class.new(:blue) }

  describe '#one_square_move' do
    context 'when the Pawn color is Red and the next square is IN the board' do
      subject(:pawn_red) { described_class.new(:red) }

      before do
        allow(pawn_red).to receive(:inside_board?).and_return(true)
      end

      it 'returns a 1 element array of a valid square the Pawn can move forward to' do
        square = [3, 1]
        valid_move = [[2, 1]]
        create_move = pawn_red.one_square_move(square)
        expect(create_move).to eq(valid_move)
      end
    end

    context 'when the Pawn color is Red and the next square is NOT in the board' do
      subject(:pawn_red) { described_class.new(:red) }

      before do
        allow(pawn_red).to receive(:inside_board?).and_return(false)
      end

      it 'returns an empty array' do
        square = [8, 7]
        create_move = pawn_red.one_square_move(square)
        expect(create_move).to eq([])
      end
    end

    context 'when the Pawn color is Blue and the next square is IN the board' do
      subject(:pawn_blue) { described_class.new(:blue) }

      before do
        allow(pawn_blue).to receive(:inside_board?).and_return(true)
      end

      it 'returns a 1 element array of a valid square the Pawn can move forward to' do
        square = [5, 4]
        valid_move = [[6, 4]]
        create_move = pawn_blue.one_square_move(square)
        expect(create_move).to eq(valid_move)
      end
    end

    context 'when the Pawn color is Blue and the next square is NOT in the board' do
      subject(:pawn_blue) { described_class.new(:blue) }

      before do
        allow(pawn_blue).to receive(:inside_board?).and_return(false)
      end

      it 'returns an empty array' do
        square = [3, 4]
        create_move = pawn_blue.one_square_move(square)
        expect(create_move).to eq([])
      end
    end
  end

  describe '#two_square_move' do
    context 'when the Pawn is Red and is ON the starting position' do
      subject(:pawn_red) { described_class.new(:red) }

      before do
        allow(pawn_red).to receive(:inside_board?).and_return(true)
      end

      it 'returns the 2nd valid square the Pawn can move up to' do
        square = [6, 2]
        valid_moves = [[5, 2], [4, 2]]
        create_move = pawn_red.two_square_move(square)
        expect(create_move).to eq(valid_moves)
      end
    end

    context 'when the Pawn is Red and is NOT on the starting position' do
      subject(:pawn_red) { described_class.new(:red) }

      before do
        allow(pawn_red).to receive(:inside_board?).and_return(true)      end

      it 'returns the 1st valid square the Pawn can move to' do
        square = [5, 2]
        valid_move = [[4, 2]]
        create_move = pawn_red.two_square_move(square)
        expect(create_move).to eq(valid_move)
      end
    end

    context 'when the Pawn is Red but out of bounds' do
      subject(:pawn_red) { described_class.new(:red) }

      before do
        allow(pawn_red).to receive(:inside_board?).and_return(false)
      end

      it 'returns empty array' do
        square = [5, 2]
        create_move = pawn_red.two_square_move(square)
        expect(create_move).to eq([])
      end
    end

    context 'when the Pawn is Blue and is ON the starting position' do
      subject(:pawn_blue) { described_class.new(:blue) }

      before do
        allow(pawn_blue).to receive(:inside_board?).and_return(true)
      end

      it 'returns the 2nd valid square the Pawn can move up to' do
        square = [1, 2]
        valid_moves = [[2, 2], [3, 2]]
        create_move = pawn_blue.two_square_move(square)
        expect(create_move).to eq(valid_moves)
      end
    end

    context 'when the Pawn is Blue and is NOT on the starting position' do
      subject(:pawn_blue) { described_class.new(:blue) }

      before do
        allow(pawn_blue).to receive(:inside_board?).and_return(true)      end

      it 'returns the 1st valid square the Pawn can move to' do
        square = [4, 2]
        valid_move = [[5, 2]]
        create_move = pawn_blue.two_square_move(square)
        expect(create_move).to eq(valid_move)
      end
    end

    context 'when the Pawn is Blue but out of bounds' do
      subject(:pawn_blue) { described_class.new(:blue) }

      before do
        allow(pawn_blue).to receive(:inside_board?).and_return(false)
      end

      it 'returns empty array' do
        square = [6, 7]
        create_move = pawn_blue.two_square_move(square)
        expect(create_move).to eq([])
      end
    end
  end

  describe '#inside_board?' do
    context 'when the square is inside the board' do
      it 'returns true' do
        square = [5, 7]
        inside = pawn.inside_board?(square)
        expect(inside).to be true
      end
    end

    context 'when the square is not inside the board' do
      it 'returns false' do
        square = [8, 9]
        inside = pawn.inside_board?(square)
        expect(inside).to be false
      end
    end
  end
end
