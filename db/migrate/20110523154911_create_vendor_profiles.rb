class CreateVendorProfiles < ActiveRecord::Migration
  def self.up
    create_table :vendor_profiles do |t|
      t.integer :vendor_id
      t.string :intro
      t.string :description
      t.string :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :vendor_profiles
  end
end
