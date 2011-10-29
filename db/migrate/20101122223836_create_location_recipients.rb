class CreateLocationRecipients < ActiveRecord::Migration
  def self.up
    create_table :location_recipients do |t|
      t.integer :user_id
      t.integer :drop_off_location_id
      t.string :recipient_first_name
      t.string :recipient_last_name

      t.timestamps
    end
  end

  def self.down
    drop_table :location_recipients
  end
end
