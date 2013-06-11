class CreateUserTypes < ActiveRecord::Migration
  def change
    create_table :user_types do |t|
      t.string :u_type

      t.timestamps
    end
    sql = ActiveRecord::Base.connection
    sql.execute("INSERT INTO user_types (u_type,created_at,updated_at) VALUES ('Free','2011-01-18 06:46:17.503339','2011-01-18 06:46:17.503339')")
    sql.execute("INSERT INTO user_types (u_type,created_at,updated_at) VALUES ('Paid','2011-01-18 06:46:17.503339','2011-01-18 06:46:17.503339')")
   
  end
end
