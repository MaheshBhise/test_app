class RenameTableTestToExam < ActiveRecord::Migration
  def up
  	rename_table :tests, :exams
  end

  def down
  	rename_table :exams, :tests
  end
end
