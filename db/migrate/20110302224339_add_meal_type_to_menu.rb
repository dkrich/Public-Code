class AddMealTypeToMenu < ActiveRecord::Migration
  def self.up
    add_column :menus, :meal_type, :integer, :default => 1
  end

  def self.down
    remove_column :menus, :meal_type
  end
end
