class AddLocationSelectionIdToMealOrder < ActiveRecord::Migration
  def self.up
    add_column :meal_orders, :location_selection_id, :integer
  end

  def self.down
    remove_column :meal_orders, :location_selection_id
  end
end
