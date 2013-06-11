class CreateUserExamSessions < ActiveRecord::Migration
  def change
    create_table :user_exam_sessions do |t|
      t.integer :user_id
      t.integer :exam_id
      t.integer :time_remaining
      t.timestamps
    end
  end
end
