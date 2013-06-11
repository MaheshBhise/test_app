require 'mime/types'
class Image < ActiveRecord::Base
  # attr_accessible :imageable_id, :imageable_type,:picture
  # belongs_to :imageable, :polymorphic => true

  has_attached_file :picture, :path => ":rails_root/public/app_pictures/:id/:style_:basename.:extension",
    :url => "/app_pictures/:id/:style_:basename.:extension",
    :styles => {
    :thumb  => "300x225>",
    :medium=> "620x465>" }, :whiny => false
  validates_attachment_size  :picture, :less_than => 600.kilobytes, :message => "Please select picture upto 600 KB file size."
end
