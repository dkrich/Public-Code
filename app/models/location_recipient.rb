class LocationRecipient < ActiveRecord::Base
  belongs_to :user
  has_one :recipient_regular_schedule #, :dependent => :destroy
  has_many :recipient_temporary_schedule #, :dependent => :destroy
  validates_presence_of :recipient_first_name
  validates_presence_of :recipient_last_name
end
