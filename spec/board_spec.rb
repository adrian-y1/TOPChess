# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/game_pieces/queen'
require_relative '../lib/game_pieces/rook'
require_relative '../lib/game_pieces/knight'
require_relative '../lib/game_pieces/pawn'
require_relative '../lib/game_pieces/king'
require_relative '../lib/game_pieces/bishop'
require_relative '../lib/end_game_manager'
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
    let(:end_game_manager) { EndGameManager.new(board) }

    context "when blue player's queen can make illegal moves that put the King in check" do
      before do
        board.board[0][4] = blue_king
        board.board[1][4] = blue_queen
        board.board[7][4] = red_queen
      end

      it "changes the blue queen's valid moves array and removes the illegal moves" do
        player_pieces = end_game_manager.find_player_pieces(blue_player.color)
        valid_moves = [[[2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4]]]
        expect do
          board.remove_illegal_moves(blue_player, end_game_manager, player_pieces)
        end.to change(blue_queen, :valid_moves).to valid_moves
      end
    end

    context "when the blue player's King can make illegal moves that puts it in check" do
      before do
        board.board[3][4] = blue_king
        board.board[6][3] = red_queen
      end

      it "changes the blue King's valid moves array and removes the illegal moves" do
        player_pieces = end_game_manager.find_player_pieces(blue_player.color)
        valid_moves = [[[2, 4]], [[4, 4]], [[3, 5]], [[2, 5]]]
        expect do
          board.remove_illegal_moves(blue_player, end_game_manager, player_pieces)
        end.to change(blue_king, :valid_moves).to valid_moves
      end
    end
  end

  describe '#find_available_piece_coordinates' do
    let(:blue_player) { Player.new(:blue) }
    let(:end_game_manager) { EndGameManager.new(board) }

    context 'when the board is initially set up' do
      before do
        board.setup_board
      end

      it 'returns 10 available piece coordinates to move (b8, g8, a7, b7, c7, d7, e7, f7, g7, h7)' do
        available_coordinates = 'b8, g8, a7, b7, c7, d7, e7, f7, g7, h7'
        find_available_coordinates = board.find_available_piece_coordinates(blue_player, end_game_manager)
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
        find_available_coordinates = board.find_available_piece_coordinates(blue_player, end_game_manager)
        expect(find_available_coordinates).to eq(available_pieces)
      end
    end
  end

  describe '#find_valid_piece_move_coordinates' do
    let(:red_player) { Player.new(:red) }
    let(:blue_player) { Player.new(:blue) }
    let(:end_game_manager) { EndGameManager.new(board) }

    context "when given a piece's coordinates" do
      before do
        board.setup_board
        board.move('d1', 'b5')
      end

      it "returns coordinates of all the piece's moves" do
        pieces = board.find_available_piece_coordinates(red_player, end_game_manager)
        piece_moves_coordinates = 'a5, c5, d5, e5, f5, g5, h5, b6, b7, b4, b3, a6, a4, c6, d7, c4, d3'
        find_move_coordinates = board.find_valid_piece_move_coordinates('b5')
        expect(find_move_coordinates).to eq(piece_moves_coordinates)
      end
    end

    context 'when a piece cannot make any legal moves' do
      before do
        board.setup_board
        board.move('d1', 'b5')
      end

      it 'returns empty str' do
        pieces = board.find_available_piece_coordinates(blue_player, end_game_manager)
        find_move_coordinates = board.find_valid_piece_move_coordinates('d7')
        expect(find_move_coordinates).to eq('')
      end
    end
  end

  describe '#moved_two_squares?' do
    context 'given start square [1, 2] and destination square [3, 2]' do
      it 'returns true' do
        start = [1, 2]
        destination = [3, 2]
        two_move = board.moved_two_squares?(start, destination)
        expect(two_move).to be true
      end
    end

    context 'given start square [1, 2] and destination square [2, 2]' do
      it 'returns false' do
        start = [1, 2]
        destination = [2, 2]
        two_move = board.moved_two_squares?(start, destination)
        expect(two_move).to be false
      end
    end

    context 'given start square [6, 2] and destination square [6, 4]' do
      it 'returns false' do
        start = [6, 2]
        destination = [6, 4]
        two_move = board.moved_two_squares?(start, destination)
        expect(two_move).to be false
      end
    end
  end

  describe '#adjacent_en_passant?' do
    let(:blue_pawn) { Pawn.new(:blue) }
    let(:red_pawn) { Pawn.new(:red) }

    context 'when En Passant is available for blue player on the right square' do
      before do
        board.board[1][3] = blue_pawn
        board.board[6][4] = red_pawn
        board.move('d7', 'd4')
        board.move('e2', 'e4')
      end

      it 'returns true' do
        player_pawns = [{ piece: blue_pawn, current_square: [4, 3] }]
        right_en_passant = board.adjacent_en_passant?(player_pawns, 4, 1)
        expect(right_en_passant).to be true
      end
    end

    context 'when En Passant is available for blue player on the left square' do
      before do
        board.board[1][5] = blue_pawn
        board.board[6][4] = red_pawn
        board.move('f7', 'f4')
        board.move('e2', 'e4')
      end

      it 'returns true' do
        player_pawns = [{ piece: blue_pawn, current_square: [4, 5] }]
        left_en_passant = board.adjacent_en_passant?(player_pawns, 4, -1)
        expect(left_en_passant).to be true
      end
    end

    context 'when En Passant is not available for blue player on the right square' do
      before do
        board.board[1][5] = blue_pawn
        board.board[6][4] = red_pawn
        board.move('f7', 'f3')
        board.move('e2', 'e4')
      end

      it 'returns false' do
        player_pawns = [{ piece: blue_pawn, current_square: [4, 5] }]
        right_en_passant = board.adjacent_en_passant?(player_pawns, 4, 1)
        expect(right_en_passant).to be false
      end
    end

    context 'when En Passant is not available for blue player on the left square' do
      before do
        board.board[1][3] = blue_pawn
        board.board[6][4] = red_pawn
        board.move('d7', 'd5')
        board.move('e2', 'e4')
      end

      it 'returns false' do
        player_pawns = [{ piece: blue_pawn, current_square: [4, 3] }]
        left_en_passant = board.adjacent_en_passant?(player_pawns, 4, -1)
        expect(left_en_passant).to be false
      end
    end

    context 'when En Passant is available for red player on the left square' do
      before do
        board.board[6][4] = red_pawn
        board.board[1][3] = blue_pawn
        board.move('e2', 'e5')
        board.move('d7', 'd5')
      end

      it 'returns true' do
        player_pawns = [{ piece: red_pawn, current_square: [3, 4] }]
        left_en_passant = board.adjacent_en_passant?(player_pawns, 3, -1)
        expect(left_en_passant).to be true
      end
    end

    context 'when En Passant is available for red player on the right square' do
      before do
        board.board[6][4] = red_pawn
        board.board[1][5] = blue_pawn
        board.move('e2', 'e5')
        board.move('f7', 'f5')
      end

      it 'returns true' do
        player_pawns = [{ piece: red_pawn, current_square: [3, 4] }]
        right_en_passant = board.adjacent_en_passant?(player_pawns, 3, 1)
        expect(right_en_passant).to be true
      end
    end

    context 'when En Passant is not available for red player on the right square' do
      before do
        board.board[1][3] = blue_pawn
        board.board[6][4] = red_pawn
        board.move('d7', 'd5')
        board.move('e2', 'e4')
      end

      it 'returns false' do
        player_pawns = [{ piece: red_pawn, current_square: [3, 4] }]
        right_en_passant = board.adjacent_en_passant?(player_pawns, 3, 1)
        expect(right_en_passant).to be false
      end
    end

    context 'when En Passant is not available for red player on the right square' do
      before do
        board.board[6][4] = red_pawn
        board.board[1][5] = blue_pawn
        board.move('e2', 'e5')
        board.move('f7', 'f5')
      end

      it 'returns false' do
        player_pawns = [{ piece: red_pawn, current_square: [3, 4] }]
        left_en_passant = board.adjacent_en_passant?(player_pawns, 3, -1)
        expect(left_en_passant).to be false
      end
    end
  end

  describe '#en_passant_available?' do
    let(:end_game_manager) { EndGameManager.new(board) }
    let(:red_player) { Player.new(:red) }
    let(:blue_player) { Player.new(:blue) }

    before do
      board.setup_board
    end

    context 'when En Passant is available for the red player' do
      before do
        board.move('b2', 'b4')
        board.move('h7', 'h5')
        board.move('b4', 'b5')
        board.move('c7', 'c5')
      end

      it 'returns true' do
        en_passant = board.en_passant_available?(red_player, end_game_manager)
        expect(en_passant).to be true
      end
    end

    context 'when En Passant is not available for the red player' do
      before do
        board.move('b2', 'b4')
        board.move('c7', 'c5')
        board.move('b4', 'b5')
      end

      it 'returns false' do
        en_passant = board.en_passant_available?(red_player, end_game_manager)
        expect(en_passant).to be false
      end
    end

    context 'when En Passant is available for the blue player' do
      before do
        board.move('h7', 'h5')
        board.move('a2', 'a4')
        board.move('h5', 'h4')
        board.move('g2', 'g4')
      end

      it 'returns true' do
        en_passant = board.en_passant_available?(blue_player, end_game_manager)
        expect(en_passant).to be true
      end
    end

    context 'when En Passant is not available for the blue player' do
      before do
        board.move('c7', 'c5')
        board.move('b2', 'b4')
        board.move('c5', 'c4')
      end

      it 'returns false' do
        en_passant = board.en_passant_available?(blue_player, end_game_manager)
        expect(en_passant).to be false
      end
    end
  end

  describe '#create_en_passant_move' do
    let(:blue_player) { Player.new(:blue) }
    let(:red_player) { Player.new(:red) }

    context "when given the blue player's Pawn's current square ([4, 2]) with left direction (-1)" do
      it "returns the left diagonal square from the Pawn's current square ([5, 1])" do
        current_square = [4, 2]
        left_diagonal = [[5, 1]]
        create_move = board.create_en_passant_move(blue_player, current_square, -1)
        expect(create_move).to eq(left_diagonal)
      end
    end

    context "when given the blue player's Pawn's current square ([4, 2]) with right direction (1)" do
      it "returns the right diagonal square from the Pawn's current square ([5, 3])" do
        current_square = [4, 2]
        right_diagonal = [[5, 3]]
        create_move = board.create_en_passant_move(blue_player, current_square, 1)
        expect(create_move).to eq(right_diagonal)
      end
    end

    context "when given the red player's Pawn's current square ([3, 4]) with left direction (-1)" do
      it "returns the left diagonal square from the Pawn's current square ([2, 3])" do
        current_square = [3, 4]
        left_diagonal = [[2, 3]]
        create_move = board.create_en_passant_move(red_player, current_square, -1)
        expect(create_move).to eq(left_diagonal)
      end
    end

    context "when given the red player's Pawn's current square ([3, 4]) with right direction (1)" do
      it "returns the right diagonal square from the Pawn's current square ([2, 5])" do
        current_square = [3, 4]
        right_diagonal = [[2, 5]]
        create_move = board.create_en_passant_move(red_player, current_square, 1)
        expect(create_move).to eq(right_diagonal)
      end
    end
  end

  describe '#store_en_passant' do
    let(:end_game_manager) { EndGameManager.new(board) }
    let(:red_pawn) { Pawn.new(:red) }
    let(:blue_pawn) { Pawn.new(:blue) }

    context 'when the blue Pawn can make an En Passant move' do
      let(:blue_player) { Player.new(:blue) }

      before do
        board.board[1][0] = blue_pawn
        board.board[6][1] = red_pawn
        board.move('a7', 'a4')
        board.move('b2', 'b4')
      end

      it "adds the En Passant move to the blue Pawn's valid moves" do
        player_pieces = end_game_manager.find_player_pieces(blue_player.color)
        new_valid_moves = [[[5, 0]], [[5, 1]]]
        expect do
          board.store_en_passant(blue_player, end_game_manager,
                                 player_pieces)
        end.to change(blue_pawn, :valid_moves).to new_valid_moves
      end
    end

    context 'when the red Pawn can make an En Passant move' do
      let(:red_player) { Player.new(:red) }

      before do
        board.board[6][4] = red_pawn
        board.board[1][5] = blue_pawn
        board.move('e2', 'e5')
        board.move('f7', 'f5')
      end

      it "adds the En Passant move to the red Pawn's valid moves" do
        player_pieces = end_game_manager.find_player_pieces(red_player.color)
        new_valid_moves = [[[2, 4]], [[2, 5]]]
        expect do
          board.store_en_passant(red_player, end_game_manager,
                                 player_pieces)
        end.to change(red_pawn, :valid_moves).to new_valid_moves
      end
    end
  end

  describe '#can_castle?' do
    let(:blue_player) { Player.new(:blue) }
    let(:red_player) { Player.new(:red) }
    let(:end_game_manager) { EndGameManager.new(board) }

    context 'when blue player can make kingside castling' do
      before do
        board.setup_board
        board.move('g8', 'h6')
        board.move('f8', 'f5')
      end

      it 'returns true' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        castle = board.can_castle?(blue_player, player_pieces, end_game_manager)
        expect(castle).to be true
      end
    end

    context "when blue player's kingside castling's in between squares are occupied" do
      before do
        board.setup_board
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        castle = board.can_castle?(blue_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context 'when blue player can make queenside castling' do
      before do
        board.setup_board
        board.move('b8', 'c6')
        board.move('c8', 'b6')
        board.move('d8', 'a6')
      end

      it 'returns true' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        castle = board.can_castle?(blue_player, player_pieces, end_game_manager)
        expect(castle).to be true
      end
    end

    context "when blue player's queenside castling's in between squares are occupied" do
      before do
        board.setup_board
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        castle = board.can_castle?(blue_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context "when blue player's in between castling squares are being attacked" do
      before do
        board.setup_board
        board.move('b8', 'c4')
        board.move('c8', 'b4')
        board.move('d8', 'a4')
        board.move('b1', 'c6')
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        castle = board.can_castle?(blue_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context "when blue player's King is in check" do
      before do
        board.setup_board
        board.move('b8', 'c4')
        board.move('c8', 'b4')
        board.move('d8', 'a4')
        board.move('b1', 'f6')
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        castle = board.can_castle?(blue_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context "when blue player's King has moved but is at the original square" do
      before do
        board.move('e8', 'e6')
        board.move('e6', 'e8')
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        castle = board.can_castle?(blue_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context "when blue player's Rook has moved but is at the original square" do
      before do
        board.move('a8', 'a6')
        board.move('a6', 'a8')
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        castle = board.can_castle?(blue_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context 'when red player can make kingside castling' do
      before do
        board.setup_board
        board.move('g1', 'h3')
        board.move('f1', 'f4')
      end

      it 'returns true' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        castle = board.can_castle?(red_player, player_pieces, end_game_manager)
        expect(castle).to be true
      end
    end

    context "when red player's kingside castling's in between squares are occupied" do
      before do
        board.setup_board
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        castle = board.can_castle?(red_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context 'when red player can make queenside castling' do
      before do
        board.setup_board
        board.move('b1', 'c4')
        board.move('c1', 'b4')
        board.move('d1', 'a4')
      end

      it 'returns true' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        castle = board.can_castle?(red_player, player_pieces, end_game_manager)
        expect(castle).to be true
      end
    end

    context "when red player's queenside castling's in between squares are occupied" do
      before do
        board.setup_board
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        castle = board.can_castle?(red_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context "when red player's in between castling squares are being attacked" do
      before do
        board.setup_board
        board.move('b1', 'c5')
        board.move('c1', 'b5')
        board.move('d1', 'a5')
        board.move('b8', 'c3')
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        castle = board.can_castle?(red_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context "when red player's King is in check" do
      before do
        board.setup_board
        board.move('b1', 'c5')
        board.move('c1', 'b5')
        board.move('d1', 'a5')
        board.move('b8', 'f3')
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        castle = board.can_castle?(red_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context "when red player's King has moved but is at the original square" do
      before do
        board.move('e1', 'e3')
        board.move('e3', 'e1')
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        castle = board.can_castle?(red_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end

    context "when red player's Rook has moved but is at the original square" do
      before do
        board.move('a1', 'a3')
        board.move('a3', 'a1')
      end

      it 'returns false' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        castle = board.can_castle?(red_player, player_pieces, end_game_manager)
        expect(castle).to be false
      end
    end
  end

  describe '#find_castling_pieces' do
    let(:blue_player) { Player.new(:blue) }
    let(:red_player) { Player.new(:red) }
    let(:end_game_manager) { EndGameManager.new(board) }

    context 'when a castling is available for blue player' do
      before do
        board.setup_board
        board.move('g8', 'g6')
        board.move('f8', 'f6')
      end

      it 'returns a single array of the Rook and King' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        rook = { piece: board.board[0][7], current_square: [0, 7] }
        king = { piece: board.board[0][4], current_square: [0, 4] }
        castling_pieces = [[rook, king]]
        find_pieces = board.find_castling_pieces(blue_player, player_pieces, end_game_manager)
        expect(find_pieces).to eq(castling_pieces)
      end
    end

    context 'when a castling is not available for blue player' do
      before do
        board.setup_board
      end

      it 'returns empty array' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        find_pieces = board.find_castling_pieces(blue_player, player_pieces, end_game_manager)
        expect(find_pieces).to eq([])
      end
    end

    context 'when blue player can make 2 castling moves' do
      before do
        board.setup_board
        board.move('g8', 'g6')
        board.move('f8', 'f6')
        board.move('b8', 'b6')
        board.move('c8', 'c6')
        board.move('d8', 'd6')
      end

      it 'returns 2 arrays for both Rook King combos' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        rook1 = { piece: board.board[0][7], current_square: [0, 7] }
        rook2 = { piece: board.board[0][0], current_square: [0, 0] }
        king = { piece: board.board[0][4], current_square: [0, 4] }
        castling_pieces = [[rook2, king], [rook1, king]]
        find_pieces = board.find_castling_pieces(blue_player, player_pieces, end_game_manager)
        expect(find_pieces).to eq(castling_pieces)
      end
    end

    context 'when a castling is available for red player' do
      before do
        board.setup_board
        board.move('g1', 'g4')
        board.move('f1', 'f4')
      end

      it 'returns a single array of the Rook and King' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        rook = { piece: board.board[7][7], current_square: [7, 7] }
        king = { piece: board.board[7][4], current_square: [7, 4] }
        castling_pieces = [[rook, king]]
        find_pieces = board.find_castling_pieces(red_player, player_pieces, end_game_manager)
        expect(find_pieces).to eq(castling_pieces)
      end
    end

    context 'when a castling is not available for red player' do
      before do
        board.setup_board
      end

      it 'returns empty array' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        find_pieces = board.find_castling_pieces(red_player, player_pieces, end_game_manager)
        expect(find_pieces).to eq([])
      end
    end

    context 'when red player can make 2 castling moves' do
      before do
        board.setup_board
        board.move('g1', 'g4')
        board.move('f1', 'f4')
        board.move('b1', 'b4')
        board.move('c1', 'c4')
        board.move('d1', 'd4')
      end

      it 'returns 2 arrays for both Rook King combos' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        rook1 = { piece: board.board[7][7], current_square: [7, 7] }
        rook2 = { piece: board.board[7][0], current_square: [7, 0] }
        king = { piece: board.board[7][4], current_square: [7, 4] }
        castling_pieces = [[rook2, king], [rook1, king]]
        find_pieces = board.find_castling_pieces(red_player, player_pieces, end_game_manager)
        expect(find_pieces).to eq(castling_pieces)
      end
    end
  end

  describe '#store_castling_move' do
    let(:blue_player) { Player.new(:blue) }
    let(:red_player) { Player.new(:red) }
    let(:end_game_manager) { EndGameManager.new(board) }

    context 'when Castling is available for blue player' do
      before do
        board.setup_board
        board.move('g8', 'g4')
        board.move('f8', 'f4')
      end

      it "adds the Castling move to the blue King's valid moves" do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        new_valid_moves = [[[0, 5]], [[0, 6]]]
        king = board.board[0][4]
        expect { board.store_castling_move(blue_player, player_pieces, end_game_manager) }.to change {
                                                                                                king.valid_moves
                                                                                              }.to new_valid_moves
      end
    end

    context 'when Castling is not available for blue player' do
      before do
        board.setup_board
        board.move('g8', 'g4')
        board.move('f8', 'f4')
        board.move('g1', 'h6')
      end

      it 'returns nil' do
        player_pieces = end_game_manager.find_player_pieces(:blue)
        expect(board.store_castling_move(blue_player, player_pieces, end_game_manager)).to eq nil
      end
    end

    context 'when Castling is available for red player' do
      before do
        board.setup_board
        board.move('g1', 'g4')
        board.move('f1', 'f4')
      end

      it "adds the Castling move to the blue King's valid moves" do
        player_pieces = end_game_manager.find_player_pieces(:red)
        new_valid_moves = [[[7, 5]], [[7, 6]]]
        king = board.board[7][4]
        expect { board.store_castling_move(red_player, player_pieces, end_game_manager) }.to change {
                                                                                               king.valid_moves
                                                                                             }.to new_valid_moves
      end
    end

    context 'when Castling is not available for blue player' do
      before do
        board.setup_board
        board.move('g1', 'g4')
        board.move('f1', 'f4')
        board.move('g8', 'h3')
      end

      it 'returns nil' do
        player_pieces = end_game_manager.find_player_pieces(:red)
        expect(board.store_castling_move(red_player, player_pieces, end_game_manager)).to eq nil
      end
    end
  end
end
