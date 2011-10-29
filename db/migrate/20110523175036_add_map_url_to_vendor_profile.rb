class AddMapUrlToVendorProfile < ActiveRecord::Migration
  def self.up
    add_column :vendor_profiles, :map_url, :string
  end

  def self.down
    remove_column :vendor_profiles, :map_url
  end
end
