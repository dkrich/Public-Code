class CreateLocationSelections < ActiveRecord::Migration
  def self.up
    create_table :location_selections do |t|
      t.integer :delivery_date_time
      t.integer :menu_id
      t.integer :drop_off_location_time_id

      t.timestamps
    end
  end

  def self.down
    drop_table :location_selections
  end
end
