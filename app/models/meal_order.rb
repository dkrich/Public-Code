class MealOrder < ActiveRecord::Base
  belongs_to :location_selection
  belongs_to :user_order_confirmation
end
