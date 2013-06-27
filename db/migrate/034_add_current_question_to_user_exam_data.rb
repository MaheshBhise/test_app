class AddCurrentQuestionToUserExamData < ActiveRecord::Migration
  def change
    add_column :user_exam_data, :current_question_level, :integer
    add_column :user_exam_data, :consecutive_correct_answers, :integer
  end
end
