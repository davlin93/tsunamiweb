class CreateRipples < ActiveRecord::Migration
  def change
    create_table :ripples do |t|
      t.decimal :lat
      t.decimal :long
      t.decimal :radius
      t.timestamps
      t.belongs_to :wave
      t.belongs_to :user
    end
  end
end
