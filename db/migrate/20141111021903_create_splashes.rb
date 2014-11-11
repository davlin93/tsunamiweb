class CreateSplashes < ActiveRecord::Migration
  def change
    create_table :splashes do |t|
      t.decimal :lat
      t.decimal :long
      t.timestamps
      t.belongs_to :wave
      t.belongs_to :user
    end
  end
end
