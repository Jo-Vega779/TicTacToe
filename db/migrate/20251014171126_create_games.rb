class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.integer :player_x_id
      t.integer :player_o_id
      t.integer :board_id
      t.string :status

      t.timestamps
    end
  end
end
