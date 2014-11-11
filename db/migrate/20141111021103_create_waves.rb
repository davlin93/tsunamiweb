class CreateWaves < ActiveRecord::Migration
  def change
    create_table :waves do |t|
      t.text :content
      t.timestamps
    end
  end
end
