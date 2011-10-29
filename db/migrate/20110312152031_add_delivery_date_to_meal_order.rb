class AddDeliveryDateToMealOrder < ActiveRecord::Migration
  def self.up
    add_column :meal_orders, :delivery_date, :date
  end

  def self.down
    remove_column :meal_orders, :delivery_date
  end
end
