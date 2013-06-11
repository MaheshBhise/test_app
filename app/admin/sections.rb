ActiveAdmin.register Section do
  menu :priority => 4

  # Customize fiters for all the sections page block starts
  config.clear_sidebar_sections!
  #filter :course_id, :label => "Filter by Course name", :as=>:Select, :collection => Course.all.map{|b| [b.course_name,b.id]}
  #filter :section_name, :as=>:Select, :collection => Section.all
  # filter :description
  # filter :only_paid,:label=>"Select Section Type",:as=>:Select, :collection => {"Paid"=>"1","Free"=>"0"}, :include_blank => false
  # filter :max_q_level
  # filter :created_at,:label=>"Section Created Date"
  # filter :updated_at,:label=>"Section Updated Date"
  # Customize fiters for all the sections page block ends

    member_action :restore_record, :method => :get do
      Section.find(params[:id]).update_attribute(:is_deleted,false)
      respond_to do |format|
       format.html { redirect_to admin_sections_url }
      end
    end


  index do
    div :class=> "bread-nav"   do
      navigation_add Course.where("id=?",session[:course_id]).first.course_name, :controller => "sections", :id => params[:id] if session[:course_id]
       render_navigation
    end
    # div do
    #   link_to Course.where("id=?",params[:id]).first.course_name, :controller => "courses", :id => params[:id] if params[:id]
    # end
    column :section_name, :sortable => :section_name do |i|
     link_to  i.section_name, :controller=> "topics", :action => "index", :id => i.id
    end    
    column "Course name", :course_id do |s|
      s.course.course_name
    end     
    column :description
    column :video_link
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

  controller do
    def create
      is_all_valid,all_records,@invalid_data = [],[],[]
      params[:section].each do |section|
        section[:course_id] = params[:post][:course_id]
        @section = Section.new(section)
        all_records << @section
        is_all_valid << @section.valid?
        @invalid_data << (!@section.valid? ? @section.section_name : "")
      end unless params[:section].blank?
      if !all_records.blank? && !is_all_valid.include?(false)
        all_records.each do|record|
          record.save
        end
        @success = true
      else
        @success = false
      end
      respond_to do |format|
       format.js {  }
      end
    end

      def index
        index! do |format|
        session[:course_id] = params[:id] if params[:id]
        str =  session[:course_id] ? " and course_id = #{session[:course_id]}" : ""    
        @sections = Section.joins(:course).where("courses.is_deleted = false"+str).page(params[:page]) unless (params[:commit] && (params[:commit].downcase=="filter"))
        format.html
        end
      end   

      def destroy
        Section.find(params[:id]).update_attribute(:is_deleted,true)
        respond_to do |format| 
          format.html { redirect_to admin_sections_url }
        end
      end        
  end 

  form :partial => "form"

  show do
    attributes_table do
      row "Course Name" do |n|
        n.course.course_name
      end      
      row :section_name
      row :description
      row :video_link
      row 'Section subscription type' do |v|
        (v.only_paid==0) ? "Free" : "Paid"
      end
    end
    active_admin_comments
  end  
end
