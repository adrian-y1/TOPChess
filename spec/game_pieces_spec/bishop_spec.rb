# frozen_string_literal: true

require_relative '../../lib/game_pieces/bishop'
require_relative '../../lib/board'

require 'colorize'

describe Bishop do
  subject(:bishop) { described_class.new(:blue) }

  let(:bishop_board) { instance_double('board') }
  let(:top_left) { [-1, -1] }
  let(:bottom_left) { [1, -1] }
  let(:top_right) { [-1, 1] }
  let(:bottom_right) { [1, 1] }
  let(:bishop_opponent) { described_class.new(:red) }
  let(:bishop_current_player) { described_class.new(:blue) }

  describe '#create_diagonal_moves' do
    before do
      allow(bishop_board).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
    end

    context 'when the square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [9, 9]
        create_moves = bishop.create_diagonal_moves(square, top_left, bishop_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [3, 4] and the top left movement' do
      it 'returns 3 valid squares ([2, 3], [1, 2], [0, 1])' do
        square = [3, 4]
        valid_moves = [[2, 3], [1, 2], [0, 1]]
        create_moves = bishop.create_diagonal_moves(square, top_left, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 4] and the bottom left movement' do
      it 'returns 4 valid squares ([4, 3], [5, 2], [6, 1], [7, 0])' do
        square = [3, 4]
        valid_moves = [[4, 3], [5, 2], [6, 1], [7, 0]]
        create_moves = bishop.create_diagonal_moves(square, bottom_left, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 4] and the top right movement' do
      it 'returns 3 valid squares ([2, 5], [1, 6], [0, 7])' do
        square = [3, 4]
        valid_moves = [[2, 5], [1, 6], [0, 7]]
        create_moves = bishop.create_diagonal_moves(square, top_right, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [3, 4] and the bottom right movement' do
      it 'returns 3 valid squares ([4, 5], [5, 6], [6, 7])' do
        square = [3, 4]
        valid_moves = [[4, 5], [5, 6], [6, 7]]
        create_moves = bishop.create_diagonal_moves(square, bottom_right, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with top left movement and square [0, 1] is occupied by own self' do
      before do
        allow(bishop_board).to receive(:board=)
        bishop_board.board[0][1] = bishop_current_player
      end

      it 'returns 2 valid squares ([2, 3], [1, 2])' do
        square = [3, 4]
        valid_moves = [[2, 3], [1, 2]]
        create_moves = bishop.create_diagonal_moves(square, top_left, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with top left movement and square [0, 1] is occupied by opponent' do
      before do
        allow(bishop_board).to receive(:board=)
        bishop_board.board[0][1] = bishop_opponent
      end

      it 'returns 3 valid squares ([2, 3], [1, 2], [0, 1])' do
        square = [3, 4]
        valid_moves = [[2, 3], [1, 2], [0, 1]]
        create_moves = bishop.create_diagonal_moves(square, top_left, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with bottom left movement and square [6, 1] is occupied by own self' do
      before do
        allow(bishop_board).to receive(:board=)
        bishop_board.board[6][1] = bishop_current_player
      end

      it 'returns 2 valid squares ([4, 3], [5, 2])' do
        square = [3, 4]
        valid_moves = [[4, 3], [5, 2]]
        create_moves = bishop.create_diagonal_moves(square, bottom_left, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with bottom left movement and square [6, 1] is occupied by opponent' do
      before do
        allow(bishop_board).to receive(:board=)
        bishop_board.board[6][1] = bishop_opponent
      end

      it 'returns 3 valid squares ([4, 3], [5, 2], [6, 1])' do
        square = [3, 4]
        valid_moves = [[4, 3], [5, 2], [6, 1]]
        create_moves = bishop.create_diagonal_moves(square, bottom_left, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with top right movement and square [1, 6] is occupied by own self' do
      before do
        allow(bishop_board).to receive(:board=)
        bishop_board.board[1][6] = bishop_current_player
      end

      it 'returns 1 valid square ([2, 5])' do
        square = [3, 4]
        valid_moves = [[2, 5]]
        create_moves = bishop.create_diagonal_moves(square, top_right, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with top right movement and square [1, 6] is occupied by opponent' do
      before do
        allow(bishop_board).to receive(:board=)
        bishop_board.board[1][6] = bishop_opponent
      end

      it 'returns 2 valid squares ([2, 5], [1, 6])' do
        square = [3, 4]
        valid_moves = [[2, 5], [1, 6]]
        create_moves = bishop.create_diagonal_moves(square, top_right, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with bottom right movement and square [5, 6] is occupied by own self' do
      before do
        allow(bishop_board).to receive(:board=)
        bishop_board.board[5][6] = bishop_current_player
      end

      it 'returns 1 valid square ([4, 5])' do
        square = [3, 4]
        valid_moves = [[4, 5]]
        create_moves = bishop.create_diagonal_moves(square, bottom_right, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [3, 4] with bottom right movement and square [5, 6] is occupied by opponent' do
      before do
        allow(bishop_board).to receive(:board=)
        bishop_board.board[5][6] = bishop_opponent
      end

      it 'returns 2 valid squares ([4, 5], [5, 6])' do
        square = [3, 4]
        valid_moves = [[4, 5], [5, 6]]
        create_moves = bishop.create_diagonal_moves(square, bottom_right, bishop_board)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end
end
