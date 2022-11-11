# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/game_pieces/queen'
require_relative '../lib/game_pieces/knight'
require_relative '../lib/game_pieces/king'
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
      before do
        allow(board).to receive(:find_coordinates_index).with('a4').and_return([4, 0])
      end

      it 'returns true' do
        square = 'a4'
        free = board.free?(square, current_player)
        expect(free).to be true
      end
    end

    context 'when the square is not empty but occupied by opponent' do
      let(:queen_opponent) { double('queen', color: opponent.color)}

      before do
        allow(board).to receive(:find_coordinates_index).with('a4').and_return([4, 0])
      end

      it 'returns true' do
        square = 'a4'
        board.board[4][0] = queen_opponent
        free = board.free?(square, current_player)
        expect(free).to be true
      end
    end

    context 'when the square is not empty and not occupied by opponent' do
      let(:queen_current_player) { double('queen', color: current_player.color)}

      before do 
        allow(board).to receive(:find_coordinates_index).with('a4').and_return([4, 0])
      end

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
        allow(board).to receive(:find_coordinates_index).with('a4').and_return([4, 0])
        allow(board).to receive(:find_coordinates_index).with('a8').and_return([0, 0])
        allow(board).to receive(:remove_piece).with([4, 0])
        board.board[4][0] = queen_move
      end

      it 'changes/moves the piece at a4 to a8' do
        piece_coordinates = 'a4'
        destination = 'a8'
        expect { board.move(piece_coordinates, destination) }.to change { board.board[0][0] }.from(' ').to(queen_move)
      end
    end
  end

  describe '#king_in_check?' do
    let(:current_player) { double('player', color: :blue) }
    let(:king_current) { double('king', color: :blue) }
    let(:knight_opponent) { double('knight', color: :red)}

    context "when current player's king is capturable by an opponent's piece" do
      before do
        board.board[4][3] = king_current
        board.board[5][1] = knight_opponent
        knight_moves = [[[3, 0], [3, 2], [4, 3], [6, 3], [7, 2], [7, 0]]]
        allow(board).to receive(:find_king).with(current_player).and_return([4, 3])
        allow(board).to receive(:find_opponent_moves).with(current_player).and_return(knight_moves)
      end

      it 'returns true' do
        check = board.king_in_check?(current_player)
        expect(check).to be true
      end
    end

    context "when current player's king is not capturable by an opponent's piece" do
      before do
        board.board[7][7] = king_current
        board.board[5][1] = knight_opponent
        knight_moves = [[[3, 0], [3, 2], [4, 3], [6, 3], [7, 2], [7, 0]]]
        allow(board).to receive(:find_king).with(current_player).and_return([7, 7])
        allow(board).to receive(:find_opponent_moves).with(current_player).and_return(knight_moves)
      end

      it 'returns false' do
        check = board.king_in_check?(current_player)
        expect(check).to be false
      end
    end
  end
end
