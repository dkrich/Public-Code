class AddTotalCreditsPurchasedToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :total_credits_purchased, :integer, :default => 0
  end

  def self.down
    remove_column :users, :total_credits_purchased
  end
end
