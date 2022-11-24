# frozen_string_literal: true

require_relative '../../lib/game_pieces/rook'
require_relative '../../lib/board'

require 'colorize'

describe Rook do
  subject(:rook) { described_class.new(:blue) }

  let(:rook_board) { instance_double(Board) }
  let(:left_move) { [0, -1] }
  let(:right_move) { [0, 1] }
  let(:top_move) { [-1, 0] }
  let(:bottom_move) { [1, 0] }
  let(:rook_current_player) { described_class.new(:blue) }
  let(:rook_opponent) { described_class.new(:red) }

  describe '#create_directional_moves' do
    before do
      allow(rook_board).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
    end

    context 'when the column of a square is out of bounds (not between 0 & 7)' do
      it 'stops loop and returns empty array' do
        square = [3, 10]
        create_moves = rook.create_directional_moves(square, left_move, rook_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when the row of a square is out of bounds (not between 0 & 7)' do
      it 'stops loop and returns empty array' do
        square = [9, 1]
        create_moves = rook.create_directional_moves(square, top_move, rook_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [5, 6] with the left movement' do
      it 'returns 6 valid squares ([5, 5], [5, 4], [5, 3], [5, 2], [5, 1], [5, 0])' do
        square = [5, 6]
        valid_moves = [[5, 5], [5, 4], [5, 3], [5, 2], [5, 1], [5, 0]]
        create_moves = rook.create_directional_moves(square, left_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 6] with the right movement' do
      it 'returns 1 valid square ([5, 7])' do
        square = [5, 6]
        valid_moves = [[5, 7]]
        create_moves = rook.create_directional_moves(square, right_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [0, 0] with right movement and square [0, 2] is occupied by own self' do
      before do
        allow(rook_board).to receive(:board=)
        rook_board.board[0][2] = rook_current_player
      end

      it 'returns 1 valid square ([0, 1])' do
        square = [0, 0]
        valid_moves = [[0, 1]]
        create_moves = rook.create_directional_moves(square, right_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [0, 5] with left movement and square [0, 2] is occupied by own self' do
      before do
        allow(rook_board).to receive(:board=)
        rook_board.board[0][2] = rook_current_player
      end

      it 'returns 2 valid squares ([0, 4], [0, 3])' do
        square = [0, 5]
        valid_moves = [[0, 4], [0, 3]]
        create_moves = rook.create_directional_moves(square, left_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [2, 5] with left movement and square [2, 1] is occupied by opponent' do
      before do
        allow(rook_board).to receive(:board=)
        rook_board.board[2][1] = rook_opponent
      end

      it 'returns 4 valid squares ([2, 4], [2, 3], [2, 2], [2, 1])' do
        square = [2, 5]
        valid_moves = [[2, 4], [2, 3], [2, 2], [2, 1]]
        create_moves = rook.create_directional_moves(square, left_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [2, 5] with right movement and square [2, 7] is occupied by opponent' do
      before do
        allow(rook_board).to receive(:board=)
        rook_board.board[2][7] = rook_opponent
      end

      it 'returns 2 valid squares ([2, 6], [2, 7])' do
        square = [2, 5]
        valid_moves = [[2, 6], [2, 7]]
        create_moves = rook.create_directional_moves(square, right_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 3] with the top movement' do
      it 'returns 3 valid squares ([2, 3], [1, 3], [0, 3])' do
        square = [3, 3]
        valid_moves = [[2, 3], [1, 3], [0, 3]]
        create_moves = rook.create_directional_moves(square, top_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 3] with the bottom movement' do
      it 'returns 4 valid squares ([4, 3], [5, 3], [6, 3], [7, 3])' do
        square = [3, 3]
        valid_moves = [[4, 3], [5, 3], [6, 3], [7, 3]]
        create_moves = rook.create_directional_moves(square, bottom_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with top movement and square [0, 4] is occupied by own self' do
      before do
        allow(rook_board).to receive(:board=)
        rook_board.board[0][4] = rook_current_player
      end

      it 'returns 2 valid squares ([2, 4], [1, 4])' do
        square = [3, 4]
        valid_moves = [[2, 4], [1, 4]]
        create_moves = rook.create_directional_moves(square, top_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with bottom movement and square [6, 4] is occupied by own self' do
      before do
        allow(rook_board).to receive(:board=)
        rook_board.board[6][4] = rook_current_player
      end

      it 'returns 2 valid squares ([4, 4], [5, 4])' do
        square = [3, 4]
        valid_moves = [[4, 4], [5, 4]]
        create_moves = rook.create_directional_moves(square, bottom_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with top movement and square [1, 4] is occupied by opponent' do
      before do
        allow(rook_board).to receive(:board=)
        rook_board.board[1][4] = rook_opponent
      end

      it 'returns 2 valid squares ([2, 4], [1, 4])' do
        square = [3, 4]
        valid_moves = [[2, 4], [1, 4]]
        create_moves = rook.create_directional_moves(square, top_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with bottom movement and square [7, 4] is occupied by opponent' do
      before do
        allow(rook_board).to receive(:board=)
        rook_board.board[7][4] = rook_opponent
      end

      it 'returns 4 valid squares ([4, 4], [5, 4], [6, 4], [7, 4])' do
        square = [3, 4]
        valid_moves = [[4, 4], [5, 4], [6, 4], [7, 4]]
        create_moves = rook.create_directional_moves(square, bottom_move, rook_board)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end
end
