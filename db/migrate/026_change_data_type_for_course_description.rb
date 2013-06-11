class ChangeDataTypeForCourseDescription < ActiveRecord::Migration
  def up
    change_table :courses do |t|
      t.change :description, :text
    end
  end

  def down
    change_table :courses do |t|
      t.change :description, :string
    end
  end
end
