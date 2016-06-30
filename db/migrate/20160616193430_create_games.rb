class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.belongs_to :ta_te_ti, index: true
      t.belongs_to :player1, index: true
      t.belongs_to :player2, index: true

      t.timestamps null: false
    end
  end
end
