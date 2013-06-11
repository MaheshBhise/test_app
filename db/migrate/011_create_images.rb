class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :imageable_type, :limit=> 20
      t.integer :imageable_id

      t.timestamps
    end
  end
end
