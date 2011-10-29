class CreateMealOrders < ActiveRecord::Migration
  def self.up
    create_table :meal_orders do |t|
      t.integer :user_id
      t.integer :drop_off_location_id
      t.integer :meal_one_quantity, :default => 0
      t.integer :meal_two_quantity, :default => 0
      t.integer :meal_three_quantity, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :meal_orders
  end
end
