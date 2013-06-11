ActiveAdmin.register User do
	config.clear_sidebar_sections!
    index do
    column "User name", :name do |s|
      s.name
    end     	
    column "User email", :email do |s|
      s.email
    end      
    default_actions
  end
end
