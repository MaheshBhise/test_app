class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question
      t.string :image_link
      t.integer :topic_id
      t.integer :section_id
      t.integer :course_id
      t.integer :difficulty_level
      t.string :correct_answer
      t.text :long_explain
      t.string :video_link
      t.string :fake_answer1
      t.string :fake_answer2
      t.string :fake_answer3
      t.integer :only_paid,:default=>"0"
      t.text :hint1
      t.text :hint2
      t.text :hint3

      t.timestamps
    end
  end
end
