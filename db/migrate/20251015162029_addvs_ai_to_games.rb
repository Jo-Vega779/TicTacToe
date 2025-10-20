class AddvsAiToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :vs_ai, :boolean, default: false
  end
end
