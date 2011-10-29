class CreateDailyMenus < ActiveRecord::Migration
  def self.up
    create_table :daily_menus do |t|
      t.integer :menu_id
      t.integer :updated_by
      t.integer :date

      t.timestamps
    end
  end

  def self.down
    drop_table :daily_menus
  end
end
