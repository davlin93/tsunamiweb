class AddViewRecord < ActiveRecord::Migration
  def change
    create_table :view_records do |t|
      t.integer :user_id
      t.integer :wave_id
      t.timestamps
    end
  end
end
