# frozen_string_literal: true

require_relative '../../lib/game_pieces/pawn'
require_relative '../../lib/board'
require 'colorize'

describe Pawn do
  subject(:pawn) { described_class.new(:blue) }

  let(:pawn_board) { instance_double(Board) }
  let(:pawn_blue) { described_class.new(:blue) }
  let(:pawn_red) { described_class.new(:red) }
  let(:bottom_left) { [1, -1] }
  let(:bottom_right) { [1, 1] }
  let(:top_left) { [-1, -1] }
  let(:top_right) { [-1, 1] }

  before do
    allow(pawn_board).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
  end

  describe '#one_square_move' do
    context 'when given square [2, 2] and Pawn is blue, next square inside the board and empty' do
      it 'returns 1 valid square ([3, 2])' do
        square = [2, 2]
        valid_moves = [[3, 2]]
        create_moves = pawn_blue.one_square_move(square, pawn_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [2, 2] and Pawn is blue, next square inside the board but not empty' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[3][2] = pawn_blue
      end

      it 'returns empty array' do
        square = [2, 2]
        create_moves = pawn_blue.one_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [7, 2] and Pawn is blue but next square not inside the board' do
      it 'returns empty array' do
        square = [7, 2]
        create_moves = pawn_blue.one_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [2, 2] and Pawn is red, next square inside the board and empty' do
      it 'returns 1 valid square ([1, 2])' do
        square = [2, 2]
        valid_moves = [[1, 2]]
        create_moves = pawn_red.one_square_move(square, pawn_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [2, 2] and Pawn is red, next square inside the board but not empty' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[1][2] = pawn_red
      end

      it 'returns empty array' do
        square = [2, 2]
        create_moves = pawn_red.one_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [0, 2] and Pawn is red but next square not inside the board' do
      it 'returns empty array' do
        square = [0, 2]
        create_moves = pawn_red.one_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end
  end

  describe '#two_square_move' do
    context 'when given square [1, 2] and Pawn is blue, on starting position, inside the board, next square is empty and array is not empty' do
      it 'returns 2nd forward valid square ([3, 2])' do
        square = [1, 2]
        valid_moves = [[3, 2]]
        create_moves = pawn_blue.two_square_move(square, pawn_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [2, 2] and Pawn is blue but not on starting position' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[2][2] = pawn_blue
      end

      it 'returns empty arr' do
        square = [2, 2]
        create_moves = pawn_blue.two_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [2, 2] and pawn is blue, on starting position, inside board but 2nd square is not empty' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[2][2] = pawn_blue
        pawn_board.board[4][2] = pawn_blue
      end

      it 'returns empty array' do
        square = [2, 2]
        create_moves = pawn_blue.two_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [2, 2] and pawn is blue, on starting position, inside board but 1st square is not empty' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[2][2] = pawn_blue
        pawn_board.board[3][2] = pawn_blue
      end

      it 'returns empty array' do
        square = [2, 2]
        create_moves = pawn_blue.two_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [1, 9] and Pawn is blue, on starting position but not inside board' do
      it 'returns empty array' do
        square = [1, 9]
        create_moves = pawn_blue.two_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [6, 2] and Pawn is red, on starting position, inside the board, next square is empty and array is not empty' do
      it 'returns 2nd forward valid squares ([4, 2])' do
        square = [6, 2]
        valid_moves = [[4, 2]]
        create_moves = pawn_red.two_square_move(square, pawn_board)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 2] and Pawn is red but not on starting position' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[5][2] = pawn_red
      end

      it 'returns empty arr' do
        square = [5, 2]
        create_moves = pawn_red.two_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [5, 2] and pawn is red, on starting position, inside board but 2nd square is not empty' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[5][2] = pawn_red
        pawn_board.board[3][2] = pawn_red
      end

      it 'returns empty array' do
        square = [5, 2]
        create_moves = pawn_red.two_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [5, 2] and pawn is red, on starting position, inside board but 1st square is not empty' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[5][2] = pawn_red
        pawn_board.board[4][2] = pawn_red
      end

      it 'returns empty array' do
        square = [5, 2]
        create_moves = pawn_red.two_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [6, 9] and Pawn is red, on starting position but not inside board' do
      it 'returns empty array' do
        square = [6, 9]
        create_moves = pawn_red.two_square_move(square, pawn_board)
        expect(create_moves).to eq([])
      end
    end
  end

  describe '#create_diagonal_moves' do
    context 'when given square [1, 10] and is not inside the board' do
      it 'returns empty array' do
        square = [1, 10]
        create_moves = pawn_red.create_diagonal_moves(square, pawn_board, bottom_left)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [2, 2] with left movement and Pawn is blue and square [3, 1] is not occupied by opponent' do
      it 'returns empty array' do
        square = [2, 2]
        create_moves = pawn_blue.create_diagonal_moves(square, pawn_board, bottom_left)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [2, 2] with left movement and Pawn is blue and square [3, 1] is occupied by opponent' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[3][1] = pawn_red
      end

      it 'returns 1 valid square ([3, 1])' do
        square = [2, 2]
        valid_moves = [[3, 1]]
        create_moves = pawn_blue.create_diagonal_moves(square, pawn_board, bottom_left)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [2, 2] with right movement and Pawn is blue and square [3, 3] is not occupied by opponent' do
      it 'returns empty array' do
        square = [2, 2]
        create_moves = pawn_blue.create_diagonal_moves(square, pawn_board, bottom_right)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [2, 2] with right movement and Pawn is blue and square [3, 3] is occupied by opponent' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[3][3] = pawn_red
      end

      it 'returns 1 valid square ([3, 3])' do
        square = [2, 2]
        valid_moves = [[3, 3]]
        create_moves = pawn_blue.create_diagonal_moves(square, pawn_board, bottom_right)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 2] with left movement and Pawn is red and square [4, 1] is not occupied by opponent' do
      it 'returns empty array' do
        square = [5, 2]
        create_moves = pawn_red.create_diagonal_moves(square, pawn_board, top_left)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [5, 2] with left movement and Pawn is red and square [4, 1] is occupied by opponent' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[4][1] = pawn_blue
      end

      it 'returns 1 valid square ([4, 1])' do
        square = [5, 2]
        valid_moves = [[4, 1]]
        create_moves = pawn_red.create_diagonal_moves(square, pawn_board, top_left)
        expect(create_moves).to eq(valid_moves)
      end
    end

    context 'when given square [5, 2] with right movement and Pawn is red and square [4, 3] is not occupied by opponent' do
      it 'returns empty array' do
        square = [5, 2]
        create_moves = pawn_red.create_diagonal_moves(square, pawn_board, top_right)
        expect(create_moves).to eq([])
      end
    end

    context 'when given square [5, 2] with right movement and Pawn is red and square [4, 3] is occupied by opponent' do
      before do
        allow(pawn_board).to receive(:board=)
        pawn_board.board[4][3] = pawn_blue
      end

      it 'returns 1 valid square ([4, 3])' do
        square = [5, 2]
        valid_moves = [[4, 3]]
        create_moves = pawn_red.create_diagonal_moves(square, pawn_board, top_right)
        expect(create_moves).to eq(valid_moves)
      end
    end
  end

  describe '#create_second_square' do
    context 'when given square [6, 2] and Pawn is red' do
      it 'returns the 2nd valid square for the red Pawn ([4, 2])' do
        square = [6, 2]
        second_square = [4, 2]
        create_square = pawn_red.create_second_square(square)
        expect(create_square).to eq(second_square)
      end
    end

    context 'when given square [1, 2] and Pawn is blue' do
      it 'returns the 2nd valid square for the blue Pawn ([3, 2])' do
        square = [1, 2]
        second_square = [3, 2]
        create_square = pawn_blue.create_second_square(square)
        expect(create_square).to eq(second_square)
      end
    end

    context 'when given square [2, 2] none of the pawns are on starting position' do
      it 'returns back the given square ([2, 2])' do
        square = [2, 2]
        create_square = pawn_red.create_second_square(square)
        expect(create_square).to eq(square)
      end
    end
  end
end
