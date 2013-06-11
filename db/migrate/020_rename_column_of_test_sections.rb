class RenameColumnOfTestSections < ActiveRecord::Migration
  def up
  	rename_column :test_sections, :test_id, :exam_id
  end

  def down
  	rename_column :test_sections, :exam_id, :test_id
  end
end
