class Vendor < ActiveRecord::Base
  has_many :menus
  has_one  :vendor_profile, :dependent => :destroy
  has_attached_file :logo, :default_url => "/images/no_image.png",
                            :dependent => :destroy,
                            :styles => { :medium => "150x150>", :small => "70x70>" }
end
