class AddDeliveredToMealOrder < ActiveRecord::Migration
  def self.up
    add_column :meal_orders, :delivered, :boolean, :default => false
  end

  def self.down
    remove_column :meal_orders, :delivered
  end
end
