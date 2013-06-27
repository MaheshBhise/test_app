class AddDefaultValuesToBanner < ActiveRecord::Migration
  def self.up
    sql = ActiveRecord::Base.connection
    sql.execute("INSERT INTO banners (banner_heading,banner_description,created_at,updated_at) VALUES
		('How do I best the test?','This is going to be where one and all who set foot on this web page will be captured for ever. This is going to be where one','2013-06-15 06:46:17.503339','2013-06-15 06:46:17.503339')")

  end

  def self.down
    Banner.delete_all("banner_heading = 'How do I best the test?'")
  end
end
