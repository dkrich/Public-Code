class AddConfirmedToMealOrder < ActiveRecord::Migration
  def self.up
    add_column :meal_orders, :confirmed, :boolean, :default => false
  end

  def self.down
    remove_column :meal_orders, :confirmed
  end
end
