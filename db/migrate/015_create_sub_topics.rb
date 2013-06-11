class CreateSubTopics < ActiveRecord::Migration
  def change
    create_table :sub_topics do |t|
      t.integer :course_id
      t.string :description
      t.integer :max_q_level
      t.boolean :only_paid
      t.integer :section_id
      t.string :sub_topic_name
      t.string :video_link
      t.integer :topic_id
      t.timestamps
    end
  end
end
