class AddPhoneNumberAndCustomerTypeToLocationRecipient < ActiveRecord::Migration
  def self.up
    add_column :location_recipients, :phone_number_area_code, :string
    add_column :location_recipients, :phone_number_prefix, :string
    add_column :location_recipients, :phone_number_suffix, :string
    add_column :location_recipients, :customer_type, :string
  end

  def self.down
    remove_column :location_recipients, :customer_type
    remove_column :location_recipients, :phone_number_area_code
    remove_column :location_recipients, :phone_number_prefix
    remove_column :location_recipients, :phone_number_suffix
  end
end
