class Banner < ActiveRecord::Base
  attr_accessible :banner_description, :banner_heading
  has_one :image, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :image

   def display_name
    "#{self.id}"
  end
end
