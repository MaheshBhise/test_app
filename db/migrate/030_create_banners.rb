class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :banner_heading
      t.string :banner_description

      t.timestamps
    end
  end
end
