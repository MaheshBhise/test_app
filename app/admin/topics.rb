ActiveAdmin.register Topic do
  menu :priority => 5

  # Customize fiters for all the topics page block starts
  config.clear_sidebar_sections!
  # filter :course_id, :label => "Filter by Course name", :as=>:Select, :collection => Course.all.map{|b| [b.course_name,b.id]}
  # filter :section_id, :label => "Filter by Section name", :as=>:Select, :collection => Section.all.map{|b| [b.section_name,b.id]}
  # filter :topic_name
  # filter :description
  # filter :only_paid,:label=>"Select Topic Type",:as=>:Select, :collection => {"Paid"=>"1","Free"=>"0"}, :include_blank => false
  # filter :max_q_level
  # filter :created_at,:label=>"Topic Created Date"
  # filter :updated_at,:label=>"Topic Updated Date"
  # Customize fiters for all the topics page block ends

    member_action :get_sections, :method => :get do
      @sections = Section.where(:course_id=>params[:selected])
      respond_to do |format|
       format.js {  }
      end
    end

    member_action :restore_record, :method => :get do
      Topic.find(params[:id]).update_attribute(:is_deleted,false)
      respond_to do |format|
       format.html { redirect_to admin_topics_url }
      end
    end



  controller do
    def create
      is_all_valid,all_records,@invalid_data = [],[],[]
      params[:topic].each do |topic|
        topic[:course_id] = params[:post][:course_id]
        topic[:section_id] = params[:post][:section_id] 
        @topic = Topic.new(topic)
        all_records << @topic
        is_all_valid << @topic.valid?
        @invalid_data << (!@topic.valid? ? @topic.topic_name : "")
      end unless params[:topic].blank?
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
        session[:section_id] = params[:id] if params[:id]
        str =  session[:section_id] ? " and section_id = #{session[:section_id]}" : ""    
        @topics = Topic.joins([:section,:course]).where("(sections.is_deleted = false) and (courses.is_deleted = false)"+str).page(params[:page]) unless (params[:commit] && (params[:commit].downcase=="filter"))
        format.html
        end
      end   

      def destroy
        Topic.find(params[:id]).update_attribute(:is_deleted,true)
        respond_to do |format|
          format.html { redirect_to admin_topics_url }
        end
      end     
  end



  index do
    div :class=> "bread-nav" do
      navigation_add Course.where("id=?",session[:course_id]).first.course_name, :controller => "sections" if session[:course_id] 
      navigation_add Section.where("id=?",session[:section_id]).first.section_name, :controller => "topics" if session[:section_id]
       render_navigation
    end
    column :topic_name, :sortable => :topic_name do |i|
     link_to  i.topic_name, :controller=> "sub_topics", :action => "index", :id => i.id
    end      
    column "Course name", :course_id do |t|
      if !t.blank? && !t.course.blank?
        t.course.course_name
      else
        "blank"
      end  
    end 
    column "Section name", :section_id do |t|
      if !t.blank? && !t.section.blank?
        t.section.section_name
      else
        "blank"
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
 
  form :validate => true do |f|          
    render "form"                                        
  end  

  show do
    attributes_table do
      row "Course Name" do |t|
        if !t.blank? && !t.course.blank?
          t.course.course_name
        else
          "blank"
        end  
      end      
      row "Section Name" do |t|
        if !t.blank? && !t.section.blank?
          t.section.section_name
        else
          "blank"
        end  
      end
      row :topic_name
      row :description
      row 'Section subscription type' do |v|
        (v.only_paid==0) ? "Free" : "Paid"
      end
      row :video_link
      row :max_q_level      
    end
  end  
end
