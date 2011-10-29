class AddLastOrderTimeToDropOffLocationTime < ActiveRecord::Migration
  def self.up
    add_column :drop_off_location_times, :last_order_time, :time
  end

  def self.down
    remove_column :drop_off_location_times, :last_order_time
  end
end
