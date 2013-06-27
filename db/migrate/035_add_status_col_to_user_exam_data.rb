class AddStatusColToUserExamData < ActiveRecord::Migration
  def change
    add_column :user_exam_data, :status, :boolean
  end
end
