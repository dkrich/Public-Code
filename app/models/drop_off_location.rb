class DropOffLocation < ActiveRecord::Base
  has_many :user_drop_off_locations, :dependent => :destroy
end
