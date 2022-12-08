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

describe EndGame do
  subject(:end_of_game) { described_class.new(game_board) }

  let(:game_board) { Board.new }

  describe '#checkmate?' do
    let(:blue_player) { Player.new(:blue) }
    let(:blue_queen) { Queen.new(:blue) }
    let(:blue_king) { King.new(:blue) }
    let(:red_rook1) { Rook.new(:red) }
    let(:red_rook2) { Rook.new(:red) }

    context 'when the King cannot get out of check' do
      before do
        game_board.board[7][0] = blue_king
        game_board.board[5][0] = red_rook1
        game_board.board[5][1] = red_rook2
      end

      it 'returns true' do
        checkmate = end_of_game.checkmate?(blue_player)
        expect(checkmate).to be true
      end
    end

    context 'when the King can move to safe position' do
      before do
        game_board.board[0][1] = blue_king
        game_board.board[2][1] = red_rook1
      end

      it 'returns false' do
        checkmate = end_of_game.checkmate?(blue_player)
        expect(checkmate).to be false
      end
    end

    context 'when the King cant move to safe position' do
      before do
        game_board.board[7][4] = blue_king
        game_board.board[7][0] = red_rook1
        game_board.board[6][0] = red_rook2
        game_board.display
      end

      it 'returns true' do
        checkmate = end_of_game.checkmate?(blue_player)
        expect(checkmate).to be true
      end
    end

    context 'when the King can capture checking piece' do
      before do
        game_board.board[2][1] = blue_king
        game_board.board[3][1] = red_rook1
      end

      it 'returns false' do
        checkmate = end_of_game.checkmate?(blue_player)
        expect(checkmate).to be false
      end
    end

    context 'when the checking piece can be captured by another piece' do
      before do
        game_board.board[0][0] = blue_king
        game_board.board[2][0] = red_rook1
        game_board.board[2][1] = red_rook2
        game_board.board[5][0] = blue_queen
      end

      it 'returns false' do
        checkmate = end_of_game.checkmate?(blue_player)
        expect(checkmate).to be false
      end
    end

    context 'when the checking piece cannot be captured' do
      before do
        game_board.board[0][0] = blue_king
        game_board.board[2][0] = red_rook1
        game_board.board[2][1] = red_rook2
        game_board.board[3][4] = blue_queen
      end

      it 'returns true' do
        checkmate = end_of_game.checkmate?(blue_player)
        expect(checkmate).to be true
      end
    end

    context 'when the checking piece can be intercepted by another piece' do
      before do
        game_board.board[0][0] = blue_king
        game_board.board[2][0] = red_rook1
        game_board.board[2][1] = red_rook2
        game_board.board[1][3] = blue_queen
      end

      it 'returns false' do
        checkmate = end_of_game.checkmate?(blue_player)
        expect(checkmate).to be false
      end
    end

    context 'when the checking piece cannot be intercepted by another piece' do
      before do
        game_board.board[0][0] = blue_king
        game_board.board[2][0] = red_rook1
        game_board.board[2][1] = red_rook2
      end

      it 'returns true' do
        checkmate = end_of_game.checkmate?(blue_player)
        expect(checkmate).to be true
      end
    end
  end

  describe 'king_in_check?' do
    let(:blue_player) { Player.new(:blue) }
    let(:blue_king) { King.new(:blue) }
    let(:red_knight) { Knight.new(:red) }

    context 'when the king is in check' do
      before do
        game_board.board[2][1] = blue_king
        game_board.board[4][2] = red_knight
      end

      it 'returns true' do
        check = end_of_game.king_in_check?(blue_player)
        expect(check).to be true
      end
    end

    context 'when the King is not in check' do
      before do
        game_board.board[2][1] = blue_king
        game_board.board[5][2] = red_knight
      end

      it 'returns false' do
        check = end_of_game.king_in_check?(blue_player)
        expect(check).to be false
      end
    end
  end

  describe '#stalemate?' do
    let(:blue_player) { Player.new(:blue) }
    let(:blue_king) { King.new(:blue) }
    let(:red_queen) { Queen.new(:red) }

    context 'when the player is in check' do
      before do
        game_board.board[2][1] = blue_king
        game_board.board[2][5] = red_queen
      end

      it 'returns false' do
        stalemate = end_of_game.stalemate?(blue_player)
        expect(stalemate).to be false
      end
    end

    context 'when the player is not in check and has no legal moves to make' do
      before do
        game_board.board[0][0] = blue_king
        game_board.board[1][2] = red_queen
      end

      it 'returns true' do
        stalemate = end_of_game.stalemate?(blue_player)
        expect(stalemate).to be true
      end
    end

    context 'when the player is not in check and has legal moves to make' do
      before do
        game_board.board[0][1] = blue_king
        game_board.board[1][3] = red_queen
      end

      it 'returns false' do
        stalemate = end_of_game.stalemate?(blue_player)
        expect(stalemate).to be false
      end
    end
  end
end
