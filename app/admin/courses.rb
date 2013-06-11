ActiveAdmin.register Course do
  # Set Header tab priority block starts
  menu :priority => 3
  # Set Header tab priority block ends


  # Customize fiters for all the courses page block starts
  config.clear_sidebar_sections!
  #filter :course_name, :as=>:Select, :collection => Course.all
  #filter :description
  #filter :only_paid,:label=>"Select Course Type",:as=>:Select, :collection => {"Paid"=>"1","Free"=>"0"}, :include_blank => false
  #filter :max_q_level
  #filter :created_at,:label=>"Course Created Date"
  #filter :updated_at,:label=>"Course Updated Date"
  # Customize fiters for all the courses page block ends

  # Customize controllers for courses block starts
    member_action :restore_record, :method => :get do
      Course.find(params[:id]).update_attribute(:is_deleted,false)
      respond_to do |format|
       format.html { redirect_to admin_courses_url }
      end
    end


   controller do
      def create
        @course = Course.new(params[:course])
        respond_to do |format|
          if @course.save
            format.html { redirect_to admin_courses_url , notice: 'Course was successfully created.' }
            format.json { render json: @course, status: :created, location: @course }
          else
            format.html { render action: "new" }
            format.json { render json: @course.errors, status: :unprocessable_entity }
          end
        end
      end 

      def destroy
        Course.find(params[:id]).update_attribute(:is_deleted,true)
        respond_to do |format|
          format.html { redirect_to admin_courses_url }
        end
      end
  end
  # Customize controllers for courses block ends

  # Customize index page for courses block starts
  index do
    div :class=> "bread-nav" do
       render_navigation
    end
    column :course_name, :sortable => :course_name do |i|
       link_to  i.course_name, :controller=> "sections", :action => "index", :id => i.id
    end
    column :description do |v|
      div do
         simple_format v.description
      end
    end
    column "Subscription Type", :only_paid do |v|
    	(v.only_paid==0) ? "Free" : "Paid"
    end
    column do |v|
      div style: 'color:red;text-align: center;' do 
        "Deleted" if (v.is_deleted==TRUE)
      end
    end
    column do |v|
        link_to "Restore Course", {:action => "restore_record",:id=> v.id},{:class=>"button",:style=>"text-decoration:none"} if (v.is_deleted)
    end    
    default_actions
  end
  # Customize index page for courses block ends

  # Customize show page for courses block starts
  show :title => :page_title do
    attributes_table do
      row :course_name
      row :description do
        div do
          simple_format course.description
        end
      end
      row "Subscription Type" do |v|
        (v.only_paid==0) ? "Free" : "Paid"
      end
      row :video_link
      #row :max_q_level
    end
    #active_admin_comments
  end
  # Customize show page for courses block ends

  # Customize new page for courses block starts
  form :validate => true do |f|
    render "form"
  end

=begin
  form :validate => true do |f|                         
    f.inputs "Course Details" do       
      f.input :course_name, :required => true
      f.input :description, :input_html => { :class => 'autogrow', :rows => 10, :cols => 20  }               
      f.input :video_link
      f.input :only_paid,:label=>"Select Course Type",:as=>:Select, :collection => {"Paid"=>"1","Free"=>"0"}, :include_blank => false 
    end                               
    f.actions                         
  end
=end
  # Customize new page for courses block ends

end
