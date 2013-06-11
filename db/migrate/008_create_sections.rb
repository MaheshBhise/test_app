class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :course_id
      t.string :section_name
      t.integer :only_paid
      t.string :description
      t.string :video_link
      t.integer :max_q_level

      t.timestamps
    end
  end
end
