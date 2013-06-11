class AddFieldDeleted < ActiveRecord::Migration
  def up
  	add_column :courses, :is_deleted, :boolean, :default => false
  	add_column :sections, :is_deleted, :boolean, :default => false
  	add_column :topics, :is_deleted, :boolean, :default => false
  	add_column :sub_topics, :is_deleted, :boolean, :default => false
  	add_column :questions, :is_deleted, :boolean, :default => false
  	add_column :questions, :fake_answer4, :string
  end

  def down
  	remove_column :courses, :is_deleted
  	remove_column :sections, :is_deleted
  	remove_column :topics, :is_deleted
  	remove_column :sub_topics, :is_deleted
  	remove_column :questions, :is_deleted
  	remove_column :questions, :fake_answer4
  end
end
