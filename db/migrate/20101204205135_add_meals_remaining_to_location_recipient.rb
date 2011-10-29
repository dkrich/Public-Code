class AddMealsRemainingToLocationRecipient < ActiveRecord::Migration
  def self.up
    add_column :location_recipients, :meals_remaining, :integer
  end

  def self.down
    remove_column :location_recipients, :meals_remaining
  end
end
