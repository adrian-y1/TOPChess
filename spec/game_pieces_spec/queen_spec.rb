# frozen_string_literal: true

require_relative '../../lib/game_pieces/queen'
require_relative '../../lib/board'

require 'colorize'

describe Queen do
  subject(:queen) { described_class.new(:blue) }
  let(:queen_current_player) { described_class.new(:blue) }
  let(:queen_opponent) { described_class.new(:red) }
  subject(:queen_board) { double('board') }
  let(:left) { [0, -1] }
  let(:right) { [0, 1] }
  let(:top) { [-1, 0] }
  let(:bottom) { [1, 0] }
  let(:top_left) { [-1, -1] }
  let(:bottom_left) { [1, -1] }
  let(:top_right) { [-1, 1] }
  let(:bottom_right) { [1, 1] }

  describe '#create_directional_moves' do
    before do
      allow(queen_board).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
    end

    context 'when the square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [9, 10]
        create_moves = queen.create_directional_moves(square, top_right, queen_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when the column of a square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [7, 10]
        create_moves = queen.create_directional_moves(square, left, queen_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when the row of a square is out of bounds (not between 0 & 7)' do
      it 'stops loop' do
        square = [9, 5]
        create_moves = queen.create_directional_moves(square, top, queen_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given the square [5, 5] and the top left direction' do
      it 'returns 5 valid squares ([4, 4], [3, 3], [2, 2], [1, 1], [0, 0])' do
        square = [5, 5]
        valid_moves = [[4, 4], [3, 3], [2, 2], [1, 1], [0, 0]]
        create_moves = queen.create_directional_moves(square, top_left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] and the top right direction' do
      it 'returns 2 valid squares ([4, 6], [3, 7])' do
        square = [5, 5]
        valid_moves = [[4, 6], [3, 7]]
        create_moves = queen.create_directional_moves(square, top_right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] and the bottom left direction' do
      it 'returns 2 valid squares ([6, 4], [7, 3])' do
        square = [5, 5]
        valid_moves = [[6, 4], [7, 3]]
        create_moves = queen.create_directional_moves(square, bottom_left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] and the bottom right direction' do
      it 'returns 2 valid squares ([6, 6], [7, 7])' do
        square = [5, 5]
        valid_moves = [[6, 6], [7, 7]]
        create_moves = queen.create_directional_moves(square, bottom_right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] with the left movement' do
      it 'returns 5 valid squares ([5, 4], [5, 3], [5, 2], [5, 1], [5, 0])' do
        square = [5, 5]
        valid_moves = [[5, 4], [5, 3], [5, 2], [5, 1], [5, 0]]
        create_moves = queen.create_directional_moves(square, left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] with the right movement' do
      it 'returns 2 valid squares ([5, 6], [5, 7])' do
        square = [5, 5]
        valid_moves = [[5, 6], [5, 7]]
        create_moves = queen.create_directional_moves(square, right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] with the top movement' do
      it 'returns 5 valid squares ([4, 5], [3, 5], [2, 5], [1, 5], [0, 5])' do
        square = [5, 5]
        valid_moves = [[4, 5], [3, 5], [2, 5], [1, 5], [0, 5]]
        create_moves = queen.create_directional_moves(square, top, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given the square [5, 5] with the bottom movement' do
      it 'returns 2 valid squares ([6, 5], [7, 5])' do
        square = [5, 5]
        valid_moves = [[6, 5], [7, 5]]
        create_moves = queen.create_directional_moves(square, bottom, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with top left movement and square [3, 3] is occupied by own self' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[3][3] = queen_current_player
      end

      it 'returns 1 valid square ([4, 4])' do
        square = [5, 5]
        valid_moves = [[4, 4]]
        create_moves = queen.create_directional_moves(square, top_left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with top left movement and square [3, 3] is occupied by opponent' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[3][3] = queen_opponent
      end

      it 'returns 2 valid squares ([4, 4], [3, 3])' do
        square = [5, 5]
        valid_moves = [[4, 4], [3, 3]]
        create_moves = queen.create_directional_moves(square, top_left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with top right movement and square [3, 7] is occupied by own self' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[3][7] = queen_current_player
      end

      it 'returns 1 valid square ([4, 6])' do
        square = [5, 5]
        valid_moves = [[4, 6]]
        create_moves = queen.create_directional_moves(square, top_right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with top right movement and square [3, 7] is occupied by opponent' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[3][7] = queen_opponent
      end

      it 'returns 2 valid squares ([4, 6], [3, 7])' do
        square = [5, 5]
        valid_moves = [[4, 6], [3, 7]]
        create_moves = queen.create_directional_moves(square, top_right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end
    
    context 'when given square [5, 5] with bottom left movement and square [7, 3] is occupied by own self' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[7][3] = queen_current_player
      end

      it 'returns 1 valid square ([6, 4])' do
        square = [5, 5]
        valid_moves = [[6, 4]]
        create_moves = queen.create_directional_moves(square, bottom_left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with bottom left movement and square [7, 3] is occupied by opponent' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[7][3] = queen_opponent
      end

      it 'returns 2 valid squares ([6, 4], [7, 3])' do
        square = [5, 5]
        valid_moves = [[6, 4], [7, 3]]
        create_moves = queen.create_directional_moves(square, bottom_left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end
    
    context 'when given square [5, 5] with bottom right movement and square [7, 7] is occupied by own self' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[7][7] = queen_current_player
      end

      it 'returns 1 valid square ([6, 6])' do
        square = [5, 5]
        valid_moves = [[6, 6]]
        create_moves = queen.create_directional_moves(square, bottom_right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with bottom right movement and square [7, 7] is occupied by opponent' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[7][7] = queen_opponent
      end

      it 'returns 2 valid squares ([6, 6], [7, 7])' do
        square = [5, 5]
        valid_moves = [[6, 6], [7, 7]]
        create_moves = queen.create_directional_moves(square, bottom_right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end
    
    context 'when given square [5, 5] with left movement and square [5, 1] is occupied by own self' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[5][1] = queen_current_player
      end

      it 'returns 3 valid squares ([5, 4], [5, 3], [5, 2])' do
        square = [5, 5]
        valid_moves = [[5, 4], [5, 3], [5, 2]]
        create_moves = queen.create_directional_moves(square, left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with left movement and square [5, 1] is occupied by opponent' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[5][1] = queen_opponent
      end

      it 'returns 4 valid squares ([5, 4], [5, 3], [5, 2], [5, 1])' do
        square = [5, 5]
        valid_moves = [[5, 4], [5, 3], [5, 2], [5, 1]]
        create_moves = queen.create_directional_moves(square, left, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with right movement and square [5, 7] is occupied by own self' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[5][7] = queen_current_player
      end

      it 'returns 1 valid square ([5, 6])' do
        square = [5, 5]
        valid_moves = [[5, 6]]
        create_moves = queen.create_directional_moves(square, right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with right movement and square [5, 7] is occupied by opponent' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[5][7] = queen_opponent
      end

      it 'returns 2 valid squares ([5, 6], [5, 7])' do
        square = [5, 5]
        valid_moves = [[5, 6], [5, 7]]
        create_moves = queen.create_directional_moves(square, right, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with top movement and square [2, 5] is occupied by own self' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[2][5] = queen_current_player
      end

      it 'returns 2 valid squares ([4, 5], [3, 5])' do
        square = [5, 5]
        valid_moves = [[4, 5], [3, 5]]
        create_moves = queen.create_directional_moves(square, top, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with top movement and square [2, 5] is occupied by opponent' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[2][5] = queen_opponent
      end

      it 'returns 3 valid squares ([4, 5], [3, 5], [2, 5])' do
        square = [5, 5]
        valid_moves = [[4, 5], [3, 5], [2, 5]]
        create_moves = queen.create_directional_moves(square, top, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with bottom movement and square [7, 5] is occupied by own self' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[7][5] = queen_current_player
      end

      it 'returns 1 valid square ([6, 5])' do
        square = [5, 5]
        valid_moves = [[6, 5]]
        create_moves = queen.create_directional_moves(square, bottom, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 5] with bottom movement and square [7, 5] is occupied by opponent' do
      before do
        allow(queen_board).to receive(:board=)
        queen_board.board[7][5] = queen_opponent
      end

      it 'returns 2 valid squares ([6, 5], [7, 5])' do
        square = [5, 5]
        valid_moves = [[6, 5], [7, 5]]
        create_moves = queen.create_directional_moves(square, bottom, queen_board)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end
end
