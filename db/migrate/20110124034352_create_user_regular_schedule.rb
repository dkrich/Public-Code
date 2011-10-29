class CreateUserRegularSchedule < ActiveRecord::Migration
  def self.up
     create_table :user_regular_schedules do |t|
      t.integer :user_id
      t.boolean :monday_scheduled
      t.boolean :tuesday_scheduled
      t.boolean :wednesday_scheduled
      t.boolean :thursday_scheduled
      t.boolean :friday_scheduled

      t.timestamps
    end
  end

  def self.down
    drop_table :user_regular_schedules
  end
end
