class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :test_name
      t.boolean :only_paid, :default => false
      t.integer :course_id

      t.timestamps
    end
  end
end
