# frozen_string_literal: true

require_relative '../../lib/game_pieces/king'
require_relative '../../lib/board'
require 'colorize'

describe King do
  subject(:king) { described_class.new(:blue) }
  let(:king_current_player) { described_class.new(:blue) }
  let(:king_opponent) { described_class.new(:red) }
  let(:king_board) { double('board') }

  describe '#create_all_moves' do
    before do
      allow(king_board).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
    end

    context 'when given square [0, 0]' do
      it 'returns 3 valid squares ([1, 0], [1, 1], [0, 1])' do
        square = [0, 0]
        valid_moves = [[1, 0], [1, 1], [0, 1]]
        create_moves = king.create_all_moves(square, king_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [2, 3]' do
      it 'returns 8 valid squares ([1, 3], [1, 2], [2, 2], [3, 2], [3, 3], [3, 4], [2, 4], [1, 4])' do
        square = [2, 3]
        valid_moves = [[1, 3], [1, 2], [2, 2], [3, 2], [3, 3], [3, 4], [2, 4], [1, 4]]
        create_moves = king.create_all_moves(square, king_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [2, 3] with squares [1, 3] and [3, 2] occupied by own self' do
      before do
        allow(king_board).to receive(:board=)
        king_board.board[1][3] = king_current_player
        king_board.board[3][2] = king_current_player
      end

      it 'returns 6 valid squares ([1, 2], [2, 2], [3, 3], [3, 4], [2, 4], [1, 4])' do
        square = [2, 3]
        valid_moves = [[1, 2], [2, 2], [3, 3], [3, 4], [2, 4], [1, 4]]
        create_moves = king.create_all_moves(square, king_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [2, 3] with squares [1, 3] and [3, 2] occupied by opponent' do
      before do
        allow(king_board).to receive(:board=)
        king_board.board[1][3] = king_opponent
        king_board.board[3][2] = king_opponent
      end

      it 'returns 8 valid squares ([1, 3], [1, 2], [2, 2], [3, 2], [3, 3], [3, 4], [2, 4], [1, 4])' do
        square = [2, 3]
        valid_moves = [[1, 3], [1, 2], [2, 2], [3, 2], [3, 3], [3, 4], [2, 4], [1, 4]]
        create_moves = king.create_all_moves(square, king_board)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end
end
