class Game < ApplicationRecord
  belongs_to :player_x, class_name: "Player"
  belongs_to :player_o, class_name: "Player"
  belongs_to :board
  
  def current_turn_symbol
  x_count = board.state.flatten.count("X")
  o_count = board.state.flatten.count("O")
  x_count <= o_count ? "X" : "O"
  end
end
