class CreateBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :boards do |t|
      t.text :state

      t.timestamps
    end
  end
end
