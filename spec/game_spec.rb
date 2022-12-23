# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/end_game_manager'
require 'colorize'

describe Game do
  subject(:game) { described_class.new(board, end_game_manager) }

  let(:board) { instance_double(Board) }
  let(:end_game_manager) { instance_double(EndGameManager) }

  describe '#play_game' do
    context 'when the game is being played' do
      before do
        allow(board).to receive(:display)
        allow(game).to receive(:player_turn_info)
        allow(game).to receive(:play_turn)
        allow(game).to receive(:game_end?).and_return(false, true)
        allow(game).to receive(:switch_turn)
      end

      it 'calls #display method' do
        expect(board).to receive(:display)
        game.play_game
      end

      it 'calls the #play_turn method' do
        expect(game).to receive(:play_turn).at_least(:once)
        game.play_game
      end

      it 'calls the #game_end? method' do
        expect(game).to receive(:game_end?).at_least(:once)
        game.play_game
      end

      it 'calls the #switch_turn method' do
        expect(game).to receive(:switch_turn).at_least(:once)
        game.play_game
      end
    end

    context 'when the game has ended' do
      before do
        allow(board).to receive(:display)
        allow(game).to receive(:player_turn_info)
        allow(game).to receive(:play_turn)
        allow(game).to receive(:game_end?).and_return(true)
      end

      it 'calls #display method' do
        expect(board).to receive(:display)
        game.play_game
      end

      it 'calls the #play_turn method' do
        expect(game).to receive(:play_turn).at_least(:once)
        game.play_game
      end

      it 'calls the #game_end? method' do
        expect(game).to receive(:game_end?).at_least(:once)
        game.play_game
      end

      it 'does not call the #switch_turn method' do
        expect(game).not_to receive(:switch_turn)
        game.play_game
      end
    end
  end
end
