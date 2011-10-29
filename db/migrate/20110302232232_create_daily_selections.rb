class CreateDailySelections < ActiveRecord::Migration
  def self.up
    create_table :daily_selections do |t|
      t.integer :menu_type_one_id
      t.integer :menu_type_two_id
      t.integer :menu_type_three_id
      t.integer :updated_by
      t.integer :date

      t.timestamps
    end
  end

  def self.down
    drop_table :daily_selections
  end
end
