class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :meals_remaining, :total_credits_purchased, :total_credits_used
  
  def send_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
  end
  
  def is_admin(user)
    if user.admin == 1
      return true
    else
      return false
    end
  end

  has_many :orders
  has_many :user_service_plans
  has_many :user_order_confirmations
  has_one :user_drop_off_location, :dependent => :destroy
  #has_many :location_recipients, :dependent => :destroy
  has_one :user_regular_schedule, :dependent => :destroy
  has_many :user_temporary_schedules, :dependent => :destroy
                      
end
