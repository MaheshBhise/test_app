ActiveAdmin.register User do
	config.clear_sidebar_sections!
  index do
    column "User name", :name do |s|
      s.name
    end     	
    column "User email", :email do |s|
      s.email
    end
    column "Last Sign in at", :last_sign_in_at do |s|
      s.last_sign_in_at
    end    
    column "Total Sign in count", :sign_in_count do |s|
      s.sign_in_count
    end
    default_actions
  end

  show do
    attributes_table do
    row :name
    row :email
    row :last_sign_in_at
    row :sign_in_count 
    end
  end
  
  form :validate => true do |f|
    render "form"
  end 
end
