class UserExamData < ActiveRecord::Base
  attr_accessible :user_id, :exam_id, :attempted_questions, :questions_per_section, :current_question_level, :consecutive_correct_answers
  serialize :attempted_questions

  has_many :exam_results


  def update_exam_data(correct_answer, question_id)
    section_id = Question.find_by_id(question_id).section.id
    if correct_answer
      self.consecutive_correct_answers += 1
      self.current_question_level += 1 if (self.consecutive_correct_answers == 3)
    else
      self.consecutive_correct_answers = 0
      self.current_question_level -= 1 if (self.current_question_level != 1)
    end
    self.attempted_questions[section_id] -= 1
    self.save
    
    ExamResult.create(:question_id => question_id, :correct => correct_answer, :user_exam_data_id => self.id, :section_id => section_id )
  end
end
