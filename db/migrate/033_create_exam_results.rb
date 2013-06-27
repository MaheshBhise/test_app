class CreateExamResults < ActiveRecord::Migration
  def change
    create_table :exam_results do |t|
      t.integer :question_id
      t.boolean :correct
      t.integer :user_exam_data_id
      t.integer :section_id

      t.timestamps
    end
  end
end
