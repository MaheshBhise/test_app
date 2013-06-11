class AddColumnToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :sub_topic_id, :integer
  end
end
