class AddAdminIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :admin_user_id, :integer
  end
end
