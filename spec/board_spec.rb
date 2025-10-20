require 'rails_helper'

RSpec.describe Board, type: :model do
  describe '#init_board' do
    it 'initializes state as a 3x3 array of nils' do
      board = Board.new
      expect(board.state).to be_an(Array)
      expect(board.state.size).to eq(3)
      expect(board.state.flatten.all?(&:nil?)).to be true
      expect(board.state).to eq([
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ])
    end
  end

  describe '#place_symbol and #valid_move?' do
    it 'places a symbol on a valid empty cell and updates state' do
      board = Board.new
      board.place_symbol(0, 1, 'X')
      expect(board.state[0][1]).to eq('X')
      expect(board.valid_move?(0, 1)).to be false
    end
  end

  describe '#full?' do
    it 'returns false when there are empty cells' do
      board = Board.new
      expect(board.full?).to be false
    end

    it 'returns true when there are no nils' do
      board = Board.new
      board.state = Array.new(3) { Array.new(3, 'X') }
      expect(board.full?).to be true
    end
  end

  describe '#winner' do
    it 'detects a winning row' do
      board = Board.new
      board.state = [
        ['X', 'X', 'X'],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
      expect(board.winner).to eq('X')
    end

    it 'detects a winning column' do
      board = Board.new
      board.state = [
        ['O', nil, nil],
        ['O', nil, nil],
        ['O', nil, nil]
      ]
      expect(board.winner).to eq('O')
    end

    it 'detects a winning diagonal' do
      board = Board.new
      board.state = [
        ['X', nil, nil],
        [nil, 'X', nil],
        [nil, nil, 'X']
      ]
      expect(board.winner).to eq('X')
    end

    it 'detects a winning anti-diagonal' do
      board = Board.new
      board.state = [
        [nil, nil, 'O'],
        [nil, 'O', nil],
        ['O', nil, nil]
      ]
      expect(board.winner).to eq('O')
    end

    it 'returns nil when there is no winner' do
      board = Board.new
      board.state = [
        ['X', 'O', 'X'],
        ['X', 'O', 'O'],
        ['O', 'X', 'X']
      ]
      expect(board.winner).to be_nil
    end
  end
end

