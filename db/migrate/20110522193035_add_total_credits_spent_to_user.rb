class AddTotalCreditsSpentToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :total_credits_used, :integer, :default => 0
  end

  def self.down
    remove_column :users, :total_credits_used
  end
end
