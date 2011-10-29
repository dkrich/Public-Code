class CreateRecipientRegularSchedules < ActiveRecord::Migration
  def self.up
    create_table :recipient_regular_schedules do |t|
      t.integer :location_recipient_id
      t.boolean :monday_scheduled
      t.boolean :tuesday_scheduled
      t.boolean :wednesday_scheduled
      t.boolean :thursday_scheduled
      t.boolean :friday_scheduled

      t.timestamps
    end
  end

  def self.down
    drop_table :recipient_regular_schedules
  end
end
