class CreateTaTeTis < ActiveRecord::Migration
  def change
    create_table :ta_te_tis do |t|
      t.text :plays

      t.timestamps null: false
    end
  end
end
