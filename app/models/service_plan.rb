class ServicePlan < ActiveRecord::Base
  has_many :orders
end
