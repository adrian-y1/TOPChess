# frozen_string_literal: true

require_relative '../../lib/game_pieces/pawn'
require_relative '../../lib/board'
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
        allow(pawn_red).to receive(:inside_board?).and_return(true)
      end

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
        allow(pawn_blue).to receive(:inside_board?).and_return(true)
      end

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

  describe '#available_square?' do
    let(:opponent) { described_class.new(:blue)}
    let(:current_player) { described_class.new(:red)}

    context 'when the square is not empty and is occupied by opponent' do
      let(:board_available) { instance_double(Board) }
      
      before do
        allow(board_available).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
        allow(board_available).to receive(:board=)
      end

      it 'returns true' do
        board_available.board[5][1] = opponent
        board_square = board_available.board[5][1]
        available = current_player.available_square?(board_square, opponent.color)
        expect(available).to be true
      end
    end

    context 'when the square is not empty and is occupied by current player' do
      let(:board_unavailable) { instance_double(Board) }
      
      before do
        allow(board_unavailable).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
        allow(board_unavailable).to receive(:board=)
      end

      it 'returns true' do
        board_unavailable.board[5][1] = current_player
        board_square = board_unavailable.board[5][1]
        available = current_player.available_square?(board_square, opponent.color)
        expect(available).to be false
      end
    end

    context 'when the square is empty' do
      let(:board_unavailable) { instance_double(Board) }
      
      before do
        allow(board_unavailable).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
        allow(board_unavailable).to receive(:board=)
      end

      it 'returns true' do
        board_square = board_unavailable.board[5][1]
        available = current_player.available_square?(board_square, opponent.color)
        expect(available).to be false
      end
    end
  end

  describe '#blue_diagonal_move' do
    let(:board_blue) { instance_double(Board) }
    let(:current_player) { described_class.new(:blue)}
    let(:opponent) { described_class.new(:red)}

    before do
      allow(board_blue).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
      allow(board_blue).to receive(:board=)
    end

    context 'when square is inside board and bottom left square is free to move to' do
      before do
        allow(current_player).to receive(:inside_board?).and_return(true)
        allow(current_player).to receive(:available_square?).and_return(true)
      end

      it 'returns a 1 element array of the square to capture/move to' do
        square = [1, 1]
        board_blue.board[1][1] = current_player
        board_blue.board[2][0] = opponent
        bottom_left = [1, -1]
        valid_move = [[2, 0]]
        diagonal_move = current_player.blue_diagonal_move(square, board_blue, bottom_left)
        expect(diagonal_move).to eq(valid_move)
      end
    end

    context 'when square is inside board and bottom right square is free to move to' do
      before do
        allow(current_player).to receive(:inside_board?).and_return(true)
        allow(current_player).to receive(:available_square?).and_return(true)
      end

      it 'returns a 1 element array of the square to capture/move to' do
        square = [1, 1]
        board_blue.board[1][1] = current_player
        board_blue.board[2][2] = opponent
        bottom_right = [1, 1]
        valid_move = [[2, 2]]
        diagonal_move = current_player.blue_diagonal_move(square, board_blue, bottom_right)
        expect(diagonal_move).to eq(valid_move)
      end
    end

    context 'when square is not inside the board' do
      before do
        allow(current_player).to receive(:inside_board?).and_return(false)
      end

      it 'returns empty array' do
        square = [9, 9]
        bottom_right = [1, 1]
        diagonal_move = current_player.blue_diagonal_move(square, board_blue, bottom_right)
        expect(diagonal_move).to eq([])
      end
    end

    context 'when square inside board but not available to move' do
      before do
          allow(current_player).to receive(:inside_board?).and_return(true)
          allow(current_player).to receive(:available_square?).and_return(false)
      end

      it 'returns empty array' do
        square = [4, 2]
        bottom_left = [1, -1]
        diagonal_move = current_player.blue_diagonal_move(square, board_blue, bottom_left)
        expect(diagonal_move).to eq([])
      end
    end
  end

  describe '#red_diagonal_moves' do
    let(:board_red) { instance_double(Board) }
    let(:current_player) { described_class.new(:red)}
    let(:opponent) { described_class.new(:blue)}

    before do
      allow(board_red).to receive(:board).and_return(Array.new(8) { Array.new(8) { ' ' } })
      allow(board_red).to receive(:board=)
    end

    context 'when square is inside board and top left square is free to move to' do
      before do
        allow(current_player).to receive(:inside_board?).and_return(true)
        allow(current_player).to receive(:available_square?).and_return(true)
      end

      it 'returns a 1 element array of the square to capture/move to' do
        square = [5, 3]
        board_red.board[5][3] = current_player
        board_red.board[4][2] = opponent
        top_left = [-1, -1]
        valid_move = [[4, 2]]
        diagonal_move = current_player.blue_diagonal_move(square, board_red, top_left)
        expect(diagonal_move).to eq(valid_move)
      end
    end

    context 'when square is inside board and top right square is free to move to' do
      before do
        allow(current_player).to receive(:inside_board?).and_return(true)
        allow(current_player).to receive(:available_square?).and_return(true)
      end

      it 'returns a 1 element array of the square to capture/move to' do
        square = [5, 3]
        board_red.board[5][3] = current_player
        board_red.board[4][4] = opponent
        top_right = [-1, 1]
        valid_move = [[4, 4]]
        diagonal_move = current_player.blue_diagonal_move(square, board_red, top_right)
        expect(diagonal_move).to eq(valid_move)
      end
    end

    context 'when square is not inside the board' do
      before do
        allow(current_player).to receive(:inside_board?).and_return(false)
      end

      it 'returns empty array' do
        square = [10, 9]
        top_right = [-1, 1]
        diagonal_move = current_player.blue_diagonal_move(square, board_red, top_right)
        expect(diagonal_move).to eq([])
      end
    end

    context 'when square inside board but not available to move' do
      before do
          allow(current_player).to receive(:inside_board?).and_return(true)
          allow(current_player).to receive(:available_square?).and_return(false)
      end

      it 'returns empty array' do
        square = [5, 3]
        top_left = [-1, -1]
        diagonal_move = current_player.blue_diagonal_move(square, board_red, top_left)
        expect(diagonal_move).to eq([])
      end
    end
  end
end
