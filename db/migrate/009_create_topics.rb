class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :section_id
      t.integer :course_id
      t.string :topic_name
      t.integer :only_paid
      t.string :description
      t.string :video_link
      t.integer :max_q_level

      t.timestamps
    end
  end
end
