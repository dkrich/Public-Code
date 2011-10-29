class AddVendorIdToMenu < ActiveRecord::Migration
  def self.up
    add_column :menus, :vendor_id, :integer
  end

  def self.down
    remove_column :menus, :vendor_id
  end
end
