class CreateUserDropOffLocations < ActiveRecord::Migration
  def self.up
    create_table :user_drop_off_locations do |t|
      t.integer :user_id
      t.integer :drop_off_location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_drop_off_locations
  end
end
