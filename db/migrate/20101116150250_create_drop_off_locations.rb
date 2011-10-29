class CreateDropOffLocations < ActiveRecord::Migration
  def self.up
    create_table :drop_off_locations do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :map_url
      t.string :state
      t.integer :occupancy
      t.integer :square_feet

      t.timestamps
    end
  end

  def self.down
    drop_table :drop_off_locations
  end
end
