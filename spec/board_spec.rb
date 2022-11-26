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

  describe '#promotion_available?' do
    let(:blue_player) { Player.new(:blue) }
    let(:red_player) { Player.new(:red) }
    let(:blue_pawn) { Pawn.new(:blue) }
    let(:red_pawn) { Pawn.new(:red) }

    context "when blue player's Pawn is not on row index 7" do
      before do
        board.board[4][1] = blue_pawn
      end

      it 'returns false' do
        promotion = board.promotion_available?(blue_player)
        expect(promotion).to be false
      end
    end

    context "when blue player's Pawn is on row index 7" do
      before do
        board.board[7][1] = blue_pawn
      end

      it 'returns true' do
        promotion = board.promotion_available?(blue_player)
        expect(promotion).to be true
      end
    end

    context "when red player's Pawn is not on row index 0" do
      before do
        board.board[3][0] = red_pawn
      end

      it 'returns false' do
        promotion = board.promotion_available?(red_player)
        expect(promotion).to be false
      end
    end

    context "when red player's Pawn is on row index 0" do
      before do
        board.board[0][5] = red_pawn
      end

      it 'returns true' do
        promotion = board.promotion_available?(red_player)
        expect(promotion).to be true
      end
    end
  end

  describe '#square_index_to_coordinates' do
    context 'when given index of square [4, 0]' do
      it 'returns the coordinates of that square (a4)' do
        square = [4, 0]
        coordinates = board.square_index_to_coordinates(square)
        expect(coordinates).to eq('a4')
      end
    end

    context 'when given the index of square [7, 7]' do
      it 'returns the coordinates of that square (h1)' do
        square = [7, 7]
        coordinates = board.square_index_to_coordinates(square)
        expect(coordinates).to eq('h1')
      end
    end
  end
end
