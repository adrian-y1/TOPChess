# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/game_pieces/queen'
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
    let(:current_player) { double('player', color: :blue) }
    let(:opponent) { double('player', color: :red) }

    context 'when the square is empty' do
      it 'returns true' do
        square = 'a4'
        free = board.free?(square, current_player)
        expect(free).to be true
      end
    end

    context 'when the square is not empty but occupied by opponent' do
      let(:queen_opponent) { double('queen', color: opponent.color) }

      it 'returns true' do
        square = 'a4'
        board.board[4][0] = queen_opponent
        free = board.free?(square, current_player)
        expect(free).to be true
      end
    end

    context 'when the square is not empty and not occupied by opponent' do
      let(:queen_current_player) { double('queen', color: current_player.color) }

      it 'returns false' do
        square = 'a4'
        board.board[4][0] = queen_current_player
        free = board.free?(square, current_player)
        expect(free).to be false
      end
    end
  end

  describe '#move' do
    let(:queen_move) { double('queen', color: :blue) }

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

  describe '#find_checking_piece' do
    let(:blue_player) { double('player', color: :blue) }
    let(:red_player) { double('player', color: :red) }
    let(:blue_king) { double('king', color: :blue) }
    let(:red_pawn) { double('pawn', color: :red) }
    context "when a piece is checking the current player's King" do
      before do
        board.board[0][1] = blue_king
        board.board[1][2] = red_pawn
        pawn_moves = [[[0, 2], [0, 1]]]
        allow(board).to receive(:find_player_king).with(blue_player).and_return([0, 1])
        allow(red_pawn).to receive(:create_all_moves) { pawn_moves }
        allow(red_pawn).to receive(:valid_moves) { pawn_moves }
      end
      
      it "returns a 1 element hash array of the piece class instance and it's current square" do
        checking_piece = [{:piece => red_pawn, :current_square => [1, 2]}]
        find_piece = board.find_checking_piece(blue_player)
        expect(find_piece).to eq(checking_piece)
      end
    end

    context "when there are 2 pieces checking the current player's King" do
      let(:red_knight) { double('knight', color: :red) }

      before do
        board.board[0][1] = blue_king
        board.board[1][2] = red_pawn
        board.board[2][0] = red_knight
        pawn_moves = [[[0, 2], [0, 1]]]
        knight_moves = [[[0, 1]], [[1, 2]], [[3, 2]], [[4, 1]]]
        allow(board).to receive(:find_player_king).with(blue_player).and_return([0, 1])
        allow(red_knight).to receive(:create_all_moves) { knight_moves }
        allow(red_pawn).to receive(:create_all_moves) { pawn_moves }
        allow(red_knight).to receive(:valid_moves) { knight_moves }
        allow(red_pawn).to receive(:valid_moves) { pawn_moves }
      end

      it 'returns a 2 element array of hashes of the pieces class instances and their current square' do
        checking_pieces = [{:piece => red_pawn, :current_square => [1, 2]}, {:piece => red_knight, :current_square => [2, 0]}]
        find_piece = board.find_checking_piece(blue_player)
        expect(find_piece).to eq(checking_pieces)
      end
    end
  end
end
