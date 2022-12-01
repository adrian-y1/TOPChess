# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/game_pieces/queen'
require_relative '../lib/game_pieces/rook'
require_relative '../lib/game_pieces/knight'
require_relative '../lib/game_pieces/pawn'
require_relative '../lib/game_pieces/king'
require_relative '../lib/game_pieces/bishop'
require_relative '../lib/end_of_game'
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

  describe '#make_promotion' do
    let(:blue_player) { Player.new(:blue) }
    let(:blue_pawn) { Pawn.new(:blue) }

    context 'when blue player is able to make a promotion' do
      before do
        board.board[7][1] = blue_pawn
      end

      it 'changes the pawn to the chosen piece' do
        chosen_piece = 'Queen'
        expect { board.make_promotion(blue_player, chosen_piece) }.to change { board.board[7][1] }.from(blue_pawn)
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

  describe '#remove_illegal_moves' do
    let(:blue_player) { Player.new(:blue) }
    let(:blue_king) { King.new(:blue) }
    let(:blue_queen) { Queen.new(:blue) }
    let(:red_queen) { Queen.new(:red) }
    let(:game_end) { EndGame.new(board) }

    context "when blue player's queen can make illegal moves that put the King in check" do
      before do
        board.board[0][4] = blue_king
        board.board[1][4] = blue_queen
        board.board[7][4] = red_queen
      end

      it "changes the blue queen's valid moves array and removes the illegal moves" do
        player_pieces = game_end.find_player_pieces(blue_player.color)
        valid_moves = [[[2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4]]]
        expect { board.remove_illegal_moves(blue_player, game_end, player_pieces) }.to change(blue_queen, :valid_moves).to valid_moves
      end
    end

    context "when the blue player's King can make illegal moves that puts it in check" do
      before do
        board.board[3][4] = blue_king
        board.board[6][3] = red_queen
      end

      it "changes the blue King's valid moves array and removes the illegal moves" do
        player_pieces = game_end.find_player_pieces(blue_player.color)
        valid_moves = [[[2, 4]], [[4, 4]], [[3, 5]], [[2, 5]]]
        expect { board.remove_illegal_moves(blue_player, game_end, player_pieces) }.to change(blue_king, :valid_moves).to valid_moves
      end
    end
  end

  describe '#find_available_piece_coordinates' do
    let(:blue_player) { Player.new(:blue) }
    let(:game_end) { EndGame.new(board) }

    context 'when the board is initially set up' do
      before do
        board.setup_board
      end

      it 'returns 10 available piece coordinates to move (b8, g8, a7, b7, c7, d7, e7, f7, g7, h7)' do
        available_coordinates = "b8, g8, a7, b7, c7, d7, e7, f7, g7, h7"
        find_available_coordinates = board.find_available_piece_coordinates(blue_player, game_end)
        expect(find_available_coordinates).to eq(available_coordinates)
      end
    end

    context 'when moving a blue piece results in blue player being in check' do
      let(:blue_king) { King.new(:blue) }
      let(:blue_pawn) { Pawn.new(:blue) }
      let(:red_queen) { Queen.new(:red) }

      before do
        board.board[0][0] = blue_king
        board.board[1][1] = blue_pawn
        board.board[3][3] = red_queen
      end

      it 'returns only valid to move pieces (a8)' do
        available_pieces = 'a8'
        find_available_coordinates = board.find_available_piece_coordinates(blue_player, game_end)
        expect(find_available_coordinates).to eq(available_pieces)
      end
    end
  end

  describe '#find_valid_piece_move_coordinates' do
    let(:red_player) { Player.new(:red) }
    let(:blue_player) { Player.new(:blue) }
    let(:game_end) { EndGame.new(board) }

    context "when given a piece's coordinates" do
      before do
        board.setup_board
        board.move('d1', 'b5')
      end
      
      it "returns coordinates of all the piece's moves" do
        pieces = board.find_available_piece_coordinates(red_player, game_end)
        piece_moves_coordinates = "a5, c5, d5, e5, f5, g5, h5, b6, b7, b4, b3, a6, a4, c6, d7, c4, d3"
        find_move_coordinates = board.find_valid_piece_move_coordinates('b5')
        expect(find_move_coordinates).to eq(piece_moves_coordinates)
      end
    end

    context "when a piece cannot make any legal moves" do
      before do
        board.setup_board
        board.move('d1', 'b5')
      end

      it "returns empty str" do
        pieces = board.find_available_piece_coordinates(blue_player, game_end)
        find_move_coordinates = board.find_valid_piece_move_coordinates('d7')
        expect(find_move_coordinates).to eq("")
      end
    end
  end
end
