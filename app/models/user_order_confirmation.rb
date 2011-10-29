class UserOrderConfirmation < ActiveRecord::Base
  has_many :meal_orders
  belongs_to :user
end
