class AddCustomFieldsToUsers < ActiveRecord::Migration
  def change
  		add_column :users, :name, :string
  		add_column :users, :security_question_id, :integer
  		add_column :users, :security_answer, :string
  		add_column :users, :status_id, :integer
  		add_column :users, :user_type_id, :integer
  		add_column :users, :expiry_date, :datetime
  end
end
