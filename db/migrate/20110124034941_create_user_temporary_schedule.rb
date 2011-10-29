class CreateUserTemporarySchedule < ActiveRecord::Migration
  def self.up
    create_table :user_temporary_schedules do |t|
      t.integer :user_id
      t.boolean :monday_scheduled
      t.boolean :tuesday_scheduled
      t.boolean :wednesday_scheduled
      t.boolean :thursday_scheduled
      t.boolean :friday_scheduled
      t.boolean :monday_delivered
      t.boolean :tuesday_delivered
      t.boolean :wednesday_delivered
      t.boolean :thursday_delivered
      t.boolean :friday_delivered

      t.timestamps
    end
  end

  def self.down
    drop_table :user_temporary_schedules
  end
end
