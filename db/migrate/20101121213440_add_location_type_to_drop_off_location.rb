class AddLocationTypeToDropOffLocation < ActiveRecord::Migration
  def self.up
    add_column :drop_off_locations, :location_type, :string
  end

  def self.down
    remove_column :drop_off_locations, :location_type
  end
end
