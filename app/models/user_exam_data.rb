class UserExamData < ActiveRecord::Base
  attr_accessible :user_id, :exam_id, :attempted_questions
  serialize :attempted_questions
end
