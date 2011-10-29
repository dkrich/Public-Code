class AddDropOffLocationTimeIdToUserOrderConfirmation < ActiveRecord::Migration
  def self.up
    add_column :user_order_confirmations, :drop_off_location_time_id, :integer
  end

  def self.down
    remove_column :user_order_confirmations, :drop_off_location_time_id
  end
end
