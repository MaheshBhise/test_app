class CreateUserExamData < ActiveRecord::Migration
  def change
    create_table :user_exam_data do |t|
      t.integer :user_id
      t.integer :exam_id
      t.text :attempted_questions
      t.timestamps
    end
  end
end
