class AddUserOrderConfirmationIdToMealOrder < ActiveRecord::Migration
  def self.up
    add_column :meal_orders, :user_order_confirmation_id, :integer
  end

  def self.down
    remove_column :meal_orders, :user_order_confirmation_id
  end
end
