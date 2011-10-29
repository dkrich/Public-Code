class CreateDropOffLocationTimes < ActiveRecord::Migration
  def self.up
    create_table :drop_off_location_times do |t|
      t.time :delivery_time
      t.integer :drop_off_location_id
      t.string :meal_service

      t.timestamps
    end
  end

  def self.down
    drop_table :drop_off_location_times
  end
end
