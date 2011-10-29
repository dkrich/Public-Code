class CreateMealTypes < ActiveRecord::Migration
  def self.up
    create_table :meal_types do |t|
      t.integer :meal_type_id
      t.string :meal_type_name

      t.timestamps
    end
  end

  def self.down
    drop_table :meal_types
  end
end
