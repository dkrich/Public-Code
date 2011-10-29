class Menu < ActiveRecord::Base
  has_many :daily_menus, :dependent => :destroy
  has_many :menu_items, :dependent => :destroy
  belongs_to :vendor

  validates_presence_of :name
end
