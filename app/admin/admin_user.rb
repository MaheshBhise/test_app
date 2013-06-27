ActiveAdmin.register AdminUser do
  menu :priority => 2
  index do                            
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    default_actions                   
  end                                 

  filter :email                       

  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :email
      f.input :role, :as => :select, :collection => {"Super Admin" => 99,"Admin" => 90}, :required => true,:include_blank => "Please Select"
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.actions                         
  end

show do
    attributes_table do
      row :email
      row :role do |v|
        (v.role == 99) ? "Super Admin" : "Admin"
      end
      row :created_at
      row :updated_at
    end
    #active_admin_comments
  end

  controller do
      def create
        if (current_admin_user.role == 99)
          super
        else
          flash[:notice] = "Sorry!! You are not an authorized user."
          redirect_to :action => "index"
        end
      end
  end
end                                   
