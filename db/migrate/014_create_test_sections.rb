class CreateTestSections < ActiveRecord::Migration
  def change
    create_table :test_sections do |t|
      t.integer :section_id
      t.integer :test_id
      t.integer :number_of_questions
      t.float :time_alloted

      t.timestamps
    end
  end
end
