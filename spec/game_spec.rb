require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '#current_turn_symbol and #current_turn_player_name' do
    it 'returns X on an empty board' do
      game = Game.new(
        player_x: Player.new(name: 'Juan'),
        player_o: Player.new(name: 'Luis'),
        board: Board.new
      )
      expect(game.current_turn_symbol).to eq('X')
      expect(game.current_turn_player_name).to eq('Juan')
    end

    it 'returns O when X has more moves' do
      board = Board.new
      board.state = [['X', nil, nil],[nil, nil, nil],[nil, nil, nil]]
      game = Game.new(player_x: Player.new(name: 'Juan'), player_o: Player.new(name: 'Luis'), board: board)
      expect(game.current_turn_symbol).to eq('O')
      expect(game.current_turn_player_name).to eq('Luis')
    end

    it 'returns X when counts are equal' do
      board = Board.new
      board.state = [['X','O',nil],[nil,nil,nil],[nil,nil,nil]]
      game = Game.new(player_x: Player.new(name: 'Juan'), player_o: Player.new(name: 'Luis'), board: board)
      expect(game.current_turn_symbol).to eq('X')
      expect(game.current_turn_player_name).to eq('Juan')
    end
  end
end
