# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/game_pieces/queen'
require_relative '../lib/game_pieces/rook'
require_relative '../lib/game_pieces/knight'
require_relative '../lib/game_pieces/pawn'
require_relative '../lib/game_pieces/king'
require_relative '../lib/game_pieces/bishop'
require 'colorize'

describe Board do
  subject(:board) { described_class.new }

  describe '#find_coordinates_index' do
    context 'when given the coordinates of a square' do
      it 'returns the row and column index of that square in the board array' do
        square = 'a4'
        index = board.find_coordinates_index(square)
        expect(index).to eq([4, 0])
      end
    end
  end

  describe '#free?' do
    let(:current_player) { instance_double(Player, color: :blue) }
    let(:opponent) { instance_double(Player, color: :red) }

    context 'when the square is empty' do
      it 'returns true' do
        square = 'a4'
        free = board.free?(square, current_player)
        expect(free).to be true
      end
    end

    context 'when the square is not empty but occupied by opponent' do
      let(:queen_opponent) { instance_double(Queen, color: opponent.color) }

      it 'returns true' do
        square = 'a4'
        board.board[4][0] = queen_opponent
        free = board.free?(square, current_player)
        expect(free).to be true
      end
    end

    context 'when the square is not empty and not occupied by opponent' do
      let(:queen_current_player) { instance_double(Queen, color: current_player.color) }

      it 'returns false' do
        square = 'a4'
        board.board[4][0] = queen_current_player
        free = board.free?(square, current_player)
        expect(free).to be false
      end
    end
  end

  describe '#move' do
    let(:queen_move) { instance_double(Queen, color: :blue) }

    context 'when given piece coordinates a4 and desired destination of a8' do
      before do
        board.board[4][0] = queen_move
      end

      it 'changes/moves the piece at a4 to a8' do
        piece_coordinates = 'a4'
        destination = 'a8'
        expect { board.move(piece_coordinates, destination) }.to change { board.board[0][0] }.from(' ').to(queen_move)
      end
    end
  end

  describe '#checkmate?' do
    let(:blue_player) { Player.new(:blue) }
    let(:blue_queen) { Queen.new(:blue) }
    let(:blue_king) { King.new(:blue) }
    let(:red_rook1) { Rook.new(:red) }
    let(:red_rook2) { Rook.new(:red) }

    context 'when the King cannot get out of check' do
      before do
        board.board[7][0] = blue_king
        board.board[5][0] = red_rook1
        board.board[5][1] = red_rook2
      end

      it 'returns true' do
        checkmate = board.checkmate?(blue_player)
        expect(checkmate).to be true
      end
    end

    context 'when the King can move to safe position' do
      before do
        board.board[0][1] = blue_king
        board.board[2][1] = red_rook1
      end

      it 'returns false' do
        checkmate = board.checkmate?(blue_player)
        expect(checkmate).to be false
      end
    end

    context 'when the King cant move to safe position' do
      before do
        board.board[7][4] = blue_king
        board.board[7][0] = red_rook1
        board.board[6][0] = red_rook2
      end

      it 'returns true' do
        checkmate = board.checkmate?(blue_player)
        expect(checkmate).to be true
      end
    end

    context 'when the King can capture checking piece' do
      before do
        board.board[2][1] = blue_king
        board.board[3][1] = red_rook1
      end

      it 'returns false' do
        checkmate = board.checkmate?(blue_player)
        expect(checkmate).to be false
      end
    end

    context 'when the checking piece can be captured by another piece' do
      before do
        board.board[0][0] = blue_king
        board.board[2][0] = red_rook1
        board.board[2][1] = red_rook2
        board.board[5][0] = blue_queen
      end

      it 'returns false' do
        checkmate = board.checkmate?(blue_player)
        expect(checkmate).to be false
      end
    end

    context 'when the checking piece cannot be captured' do
      before do
        board.board[0][0] = blue_king
        board.board[2][0] = red_rook1
        board.board[2][1] = red_rook2
        board.board[3][4] = blue_queen
      end

      it 'returns true' do
        checkmate = board.checkmate?(blue_player)
        expect(checkmate).to be true
      end
    end

    context 'when the checking piece can be intercepted by another piece' do
      before do
        board.board[0][0] = blue_king
        board.board[2][0] = red_rook1
        board.board[2][1] = red_rook2
        board.board[1][3] = blue_queen
      end

      it 'returns false' do
        checkmate = board.checkmate?(blue_player)
        expect(checkmate).to be false
      end
    end

    context 'when the checking piece cannot be intercepted by another piece' do
      before do
        board.board[0][0] = blue_king
        board.board[2][0] = red_rook1
        board.board[2][1] = red_rook2
      end

      it 'returns true' do
        checkmate = board.checkmate?(blue_player)
        expect(checkmate).to be true
      end
    end
  end
end
