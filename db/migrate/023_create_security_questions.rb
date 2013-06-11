class CreateSecurityQuestions < ActiveRecord::Migration
  def change
    create_table :security_questions do |t|
      t.string :question

      t.timestamps
    end
    sql = ActiveRecord::Base.connection
    sql.execute("INSERT INTO security_questions (question,created_at,updated_at) VALUES ('grandfathers middle name','2011-01-18 06:46:17.503339','2011-01-18 06:46:17.503339')")
    sql.execute("INSERT INTO security_questions (question,created_at,updated_at) VALUES ('first dates last name','2011-01-18 06:46:17.503339','2011-01-18 06:46:17.503339')")
    sql.execute("INSERT INTO security_questions (question,created_at,updated_at) VALUES ('favourite place','2011-01-18 06:46:17.503339','2011-01-18 06:46:17.503339')")
  end
end
