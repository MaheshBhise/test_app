class AddDescriptionToExams < ActiveRecord::Migration
  def change
    add_column :exams, :description, :text
  end
end
