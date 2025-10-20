class Player < ApplicationRecord
    has_many :games_as_x, class_name: "Game", foreign_key: "player_x_id"
    has_many :games_as_o, class_name: "Game", foreign_key: "player_o_id"
end
