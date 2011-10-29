class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :drop_off_location_id, :integer
    add_column :users, :phone_number_area_code, :string
    add_column :users, :phone_number_prefix, :string
    add_column :users, :phone_number_suffix, :string
    add_column :users, :meals_remaining, :integer, :default => 0
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :drop_off_location_id
    remove_column :users, :phone_number_area_code
    remove_column :users, :phone_number_prefix
    remove_column :users, :phone_number_suffix
    remove_column :users, :meals_remaining
  end
end
