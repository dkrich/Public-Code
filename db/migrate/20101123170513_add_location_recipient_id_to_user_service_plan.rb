class AddLocationRecipientIdToUserServicePlan < ActiveRecord::Migration
  def self.up
    add_column :user_service_plans, :location_recipient_id, :integer
  end

  def self.down
    remove_column :user_service_plans, :location_recipient_id
  end
end
