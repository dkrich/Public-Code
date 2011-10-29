class AddPriceToMenu < ActiveRecord::Migration
  def self.up
    add_column :menus, :price, :integer
  end

  def self.down
    remove_column :menus, :price
  end
end
