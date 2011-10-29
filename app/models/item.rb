class Item < ActiveRecord::Base
  has_many :menu_items, :dependent => :destroy
  
  has_attached_file :photo, :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                            :default_url => "/images/no_image.png",
                            :dependent => :destroy
end
