class UserExamSession < ActiveRecord::Base
  attr_accessible :user_id, :exam_id, :time_remaining
  
end
