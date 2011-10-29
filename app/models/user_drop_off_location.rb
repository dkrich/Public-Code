class UserDropOffLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :drop_off_location
end
