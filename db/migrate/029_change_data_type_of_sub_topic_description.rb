class ChangeDataTypeOfSubTopicDescription < ActiveRecord::Migration
  def up
    change_table :sub_topics do |t|
      t.change :description, :text
    end
  end

  def down
    change_table :sub_topics do |t|
      t.change :description, :string
    end
  end
end
