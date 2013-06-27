class UserCourse < ActiveRecord::Base
  attr_accessible :course_id, :diagnostic_status, :user_id

  belongs_to :user
  belongs_to :course

  validates :user_id, :uniqueness => { :scope => :course_id }
end
