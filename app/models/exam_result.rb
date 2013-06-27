class ExamResult < ActiveRecord::Base
  attr_accessible :correct, :question_id, :user_exam_data_id, :section_id

  belongs_to :user_exam_data
end
