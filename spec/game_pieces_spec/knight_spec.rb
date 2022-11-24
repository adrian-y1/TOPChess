# frozen_string_literal: true

require_relative '../../lib/game_pieces/knight'
require_relative '../../lib/board'

require 'colorize'

describe Knight do
  subject(:knight) { described_class.new(:blue) }

  let(:knight_current_player) { described_class.new(:blue) }
  let(:knight_opponent) { described_class.new(:red) }
  let(:knight_board) { instance_double(Board) }

  describe '#create_all_moves' do
    before do
      allow(knight_board).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
    end

    context 'when Knight is at square [3, 4]' do
      it 'returns 8 valid squares ([1, 3], [1, 5], [2, 6], [2, 2], [4, 6], [4, 2], [5, 5], [5, 3])' do
        square = [3, 4]
        valid_moves = [[[1, 3]], [[1, 5]], [[2, 6]], [[2, 2]], [[4, 6]], [[4, 2]], [[5, 5]], [[5, 3]]]
        create_moves = knight.create_all_moves(square, knight_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when the Knight is at square [0, 0]' do
      it 'returns 2 valid squares ([1, 2], [2, 1])' do
        square = [0, 0]
        valid_moves = [[[1, 2]], [[2, 1]]]
        create_moves = knight.create_all_moves(square, knight_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when the Knight is at square [3, 4] and both square [1, 5] and [1, 3] are occupied by own self' do
      before do
        allow(knight_board).to receive(:board=)
        knight_board.board[1][5] = knight_current_player
        knight_board.board[1][3] = knight_current_player
      end

      it 'returns 6 valid squares ([1, 3], [1, 5], [2, 6], [2, 2], [4, 6], [4, 2], [5, 5], [5, 3])' do
        square = [3, 4]
        valid_moves = [[[2, 6]], [[2, 2]], [[4, 6]], [[4, 2]], [[5, 5]], [[5, 3]]]
        create_moves = knight.create_all_moves(square, knight_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when the Knight is at square [3, 4] and both square [1, 5] and [1, 3] are occupied by opponent' do
      before do
        allow(knight_board).to receive(:board=)
        knight_board.board[1][5] = knight_opponent
        knight_board.board[1][3] = knight_opponent
      end

      it 'returns 8 valid squares ([1, 3], [1, 5], [2, 6], [2, 2], [4, 6], [4, 2], [5, 5], [5, 3])' do
        square = [3, 4]
        valid_moves = [[[1, 3]], [[1, 5]], [[2, 6]], [[2, 2]], [[4, 6]], [[4, 2]], [[5, 5]], [[5, 3]]]
        create_moves = knight.create_all_moves(square, knight_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when the Knight is at square [0, 0] and all positions occupied by own self' do
      before do
        allow(knight_board).to receive(:board=)
        knight_board.board[1][2] = knight_current_player
        knight_board.board[2][1] = knight_current_player
      end

      it 'returns empty array' do
        square = [0, 0]
        create_moves = knight.create_all_moves(square, knight_board)
        expect(create_moves).to eq([])
      end
    end
  end
end
