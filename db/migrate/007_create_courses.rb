class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :course_name
      t.integer :only_paid
      t.string :description
      t.string :video_link
      t.integer :max_q_level
      
      t.timestamps
    end
  end
end
