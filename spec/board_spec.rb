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
    let(:blue_king) { double('king', color: :blue) }
    let(:red_pawn) { double('pawn', color: :red) }

    context "when a piece is checking the current player's King" do
      before do
        board.board[0][1] = blue_king
        board.board[1][2] = red_pawn

        pawn_moves = [[[0, 2], [0, 1]]]
        king_obj = [{ piece: blue_king, current_square: [0, 1] }]

        allow(board).to receive(:find_player_king).and_return(king_obj)
        allow(red_pawn).to receive(:create_all_moves) { pawn_moves }
        allow(red_pawn).to receive(:valid_moves) { pawn_moves }
      end

      it "returns a 1 element hash array of the piece class instance and it's current square" do
        checking_piece = [{ piece: red_pawn, current_square: [1, 2] }]
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
        king_obj = [{ piece: blue_king, current_square: [0, 1] }]

        allow(board).to receive(:find_player_king).with(blue_player).and_return(king_obj)
        allow(red_knight).to receive(:create_all_moves) { knight_moves }
        allow(red_pawn).to receive(:create_all_moves) { pawn_moves }
        allow(red_knight).to receive(:valid_moves) { knight_moves }
        allow(red_pawn).to receive(:valid_moves) { pawn_moves }
      end

      it 'returns a 2 element array of hashes of the pieces class instances and their current square' do
        checking_pieces = [{ piece: red_pawn, current_square: [1, 2] }, { piece: red_knight, current_square: [2, 0] }]
        find_piece = board.find_checking_piece(blue_player)
        expect(find_piece).to eq(checking_pieces)
      end
    end
  end

  describe '#remove_guarded_king_moves' do
    let(:blue_player) { double('player', color: :blue) }
    let(:blue_king) { double('king', color: :blue) }
    let(:red_pawn) { double('pawn', color: :red) }
    let(:red_knight) { double('knight', color: :red) }

    context "when current player's King is in check" do
      before do
        board.board[0][1] = blue_king
        board.board[2][3] = red_pawn
        board.board[2][0] = red_knight

        knight_moves = [[[0, 1]], [[1, 2]], [[3, 2]], [[4, 1]]]
        king_obj = [{ piece: blue_king, current_square: [0, 1] }]
        king_moves = [[[0, 0], [1, 0], [1, 1], [1, 2], [0, 2]]]
        pawn_attack_moves = [[[1, 2]], [[1, 4]]]
        pawn_moves = [[[1, 3], [0, 3]]]

        allow(blue_king).to receive(:valid_moves) { king_moves }
        allow(board).to receive(:find_player_king).with(blue_player).and_return(king_obj)
        allow(red_knight).to receive(:create_all_moves) { knight_moves }
        allow(red_pawn).to receive(:create_all_moves) { pawn_moves }
        allow(red_knight).to receive(:attacking_squares) { knight_moves }
        allow(red_pawn).to receive(:attacking_squares) { pawn_attack_moves }
      end

      it "removes any of the King's valid moves that are guarded by opponent" do
        red_pieces = [{ piece: red_knight, current_square: [2, 0] }, { piece: red_pawn, current_square: [2, 3] }]
        valid_king_moves = [[0, 0], [1, 0], [1, 1], [0, 2]]
        remove_guarded_moves = board.remove_guarded_king_moves(blue_player, red_pieces)
        expect(remove_guarded_moves).to eq(valid_king_moves)
      end
    end
  end

  describe '#move_to_safe_position?' do
    let(:blue_player) { double('player', color: :blue) }
    let(:blue_king) { double('king', color: :blue) }
    let(:red_pawn) { double('pawn', color: :red) }
    let(:red_knight) { double('knight', color: :red) }

    context 'when the king has a safe position to move to' do
      before do
        board.board[1][1] = blue_king
        board.board[3][2] = red_pawn

        pawn_moves = [[[2, 2], [1, 2]]]
        pawn_attack_moves = [[[2, 1]], [[2, 3]]]
        king_moves = [[[0, 1], [0, 0], [1, 0], [2, 0], [2, 1], [2, 2], [1, 2], [0, 2]]]
        king_obj = [{ piece: blue_king, current_square: [1, 1] }]

        allow(blue_king).to receive(:valid_moves) { king_moves }
        allow(red_pawn).to receive(:create_all_moves) { pawn_moves }
        allow(red_pawn).to receive(:attacking_squares) { pawn_attack_moves }
        allow(board).to receive(:find_player_king).with(blue_player).and_return(king_obj)
      end

      it 'returns true' do
        safe_position = board.move_to_safe_position?(blue_player)
        expect(safe_position).to be true
      end
    end

    context 'when the king doesnt have a safe position to move to' do
      before do
        board.board[0][0] = blue_king
        board.board[2][0] = red_pawn
        board.board[2][2] = red_knight

        pawn_moves = [[[1, 0]]]
        pawn_attack_moves = [[[1, 1]]]
        king_moves = [[[1, 0], [1, 1], [0, 1]]]
        knight_moves = [[[0, 1]], [[0, 3]], [[1, 4]], [[1, 0]], [[3, 4]], [[3, 0]], [[4, 3]], [[4, 1]]]
        king_obj = [{ piece: blue_king, current_square: [0, 0] }]

        allow(blue_king).to receive(:valid_moves) { king_moves }
        allow(red_pawn).to receive(:create_all_moves) { pawn_moves }
        allow(red_pawn).to receive(:attacking_squares) { pawn_attack_moves }
        allow(red_knight).to receive(:create_all_moves) { knight_moves }
        allow(red_knight).to receive(:attacking_squares) { knight_moves }
        allow(board).to receive(:find_player_king).with(blue_player) { king_obj }
      end

      it 'returns false' do
        safe_position = board.move_to_safe_position?(blue_player)
        expect(safe_position).to be false
      end
    end
  end

  describe '#find_available_interceptions' do
    let(:blue_player) { double('player', color: :blue) }
    let(:blue_king) { double('king', color: :blue) }
    let(:red_rook) { double('rook', color: :red) }
    let(:red_pawn) { double('pawn', color: :red) }

    context "when King is at [0, 0] and is in check by opponent's Rook who's at [2, 0]" do
      before do
        board.board[0][0] = blue_king
        board.board[2][0] = red_rook

        king_moves = [[[1, 0], [1, 1], [0, 1]]]
        king_obj = [{ piece: blue_king, current_square: [0, 0] }]
        rook_obj = [{ piece: red_rook, current_square: [2, 0] }]
        rook_moves = [[[2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7]], [[1, 0], [0, 0]],
                      [[3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]]

        allow(blue_king).to receive(:create_all_moves) { king_moves }
        allow(red_rook).to receive(:create_all_moves) { rook_moves }
        allow(red_rook).to receive(:valid_moves) { rook_moves }
        allow(board).to receive(:find_player_king).with(blue_player) { king_obj }
        allow(board).to receive(:find_interceptable_pieces) { rook_obj }
      end

      it 'returns square [1, 0] as a interceptable square' do
        interceptable_squares = [[1, 0]]
        find_interceptions = board.find_available_interceptions(blue_player)
        expect(find_interceptions).to eq(interceptable_squares)
      end
    end

    context "when King is in check by opponent's Pawn" do
      before do
        board.board[0][0] = blue_king
        board.board[1][1] = red_pawn

        king_moves = [[[1, 0], [1, 1], [0, 1]]]
        king_obj = [{ piece: blue_king, current_square: [0, 0] }]

        allow(blue_king).to receive(:create_all_moves) { king_moves }
        allow(board).to receive(:find_player_king).with(blue_player) { king_obj }
        allow(board).to receive(:find_interceptable_pieces) { [] }
      end

      it 'returns empty array' do
        find_interceptions = board.find_available_interceptions(blue_player)
        expect(find_interceptions).to eq([])
      end
    end

    context 'when King is in check by more than 1 piece' do
      before do
        board.board[0][0] = blue_king
        board.board[1][1] = red_pawn
        board.board[2][0] = red_rook

        king_moves = [[[1, 0], [1, 1], [0, 1]]]
        king_obj = [{ piece: blue_king, current_square: [0, 0] }]
        rook_obj = [{ piece: red_rook, current_square: [2, 0] }]
        pawn_obj = [{ piece: red_pawn, current_square: [1, 1] }]
        rook_moves = [[[2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7]], [[1, 0], [0, 0]],
                      [[3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]]
        pawn_moves = [[[0, 1]]]

        allow(blue_king).to receive(:create_all_moves) { king_moves }
        allow(red_rook).to receive(:create_all_moves) { rook_moves }
        allow(red_rook).to receive(:valid_moves) { rook_moves }
        allow(red_pawn).to receive(:create_all_moves) { pawn_moves }
        allow(red_pawn).to receive(:valid_moves) { pawn_moves }
        allow(board).to receive(:find_player_king).with(blue_player) { king_obj }
        allow(board).to receive(:find_interceptable_pieces) { rook_obj }
        allow(board).to receive(:find_checking_piece) { [rook_obj, pawn_obj] }
      end

      it 'returns empty array' do
        find_interceptions = board.find_available_interceptions(blue_player)
        expect(find_interceptions).to eq([])
      end
    end
  end
end
