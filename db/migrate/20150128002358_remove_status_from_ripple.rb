class RemoveStatusFromRipple < ActiveRecord::Migration
  def change
    remove_column :ripples, :status
  end
end
