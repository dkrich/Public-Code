class AddAdminToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :integer, :default => true
  end

  def self.down
    remove_column :users, :admin
  end
end
