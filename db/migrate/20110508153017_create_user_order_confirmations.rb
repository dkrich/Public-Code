class CreateUserOrderConfirmations < ActiveRecord::Migration
  def self.up
    create_table :user_order_confirmations do |t|
      t.integer :user_id
      t.date :delivery_date
      t.integer :location_selection_id
      t.boolean :confirmed, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :user_order_confirmations
  end
end
