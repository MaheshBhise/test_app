ActiveAdmin.register SubTopic do
  menu :priority => 6

  # Customize fiters for all the sub topics page block starts
  config.clear_sidebar_sections!
  # filter :course_id, :label => "Filter by Course name", :as=>:Select, :collection => Course.all.map{|b| [b.course_name,b.id]}
  # filter :section_id, :label => "Filter by Section name", :as=>:Select, :collection => Section.all.map{|b| [b.section_name,b.id]}
  # filter :topic_id, :label => "Filter by Topic name", :as=>:Select, :collection => Topic.all.map{|b| [b.topic_name,b.id]}  
  # filter :sub_topic_name
  # filter :description
  # filter :only_paid,:label=>"Select Sub-Topic Type",:as=>:Select, :collection => {"Paid"=>"1","Free"=>"0"}, :include_blank => false
  # filter :max_q_level
  # filter :created_at,:label=>"Sub-Topic Created Date"
  # filter :updated_at,:label=>"Sub-Topic Updated Date"
  # Customize fiters for all the sub topics page block ends

    member_action :get_sections_and_topics, :method => :get do
     @distinct = params[:distinct]
     if (params[:distinct] == "post_course_id")
       @sections = Section.where(:course_id=>params[:selected])
     else
       @topics = Topic.where(:section_id=>params[:selected])
     end
      respond_to do |format|
       format.js {  }
      end
    end

    member_action :restore_record, :method => :get do
      SubTopic.find(params[:id]).update_attribute(:is_deleted,false)
      respond_to do |format|
       format.html { redirect_to admin_sub_topics_url }
      end
    end



  controller do
    def create
      is_all_valid,all_records,@invalid_data = [],[],[]
      params[:sub_topic].each do |topic|
        topic[:course_id] = params[:post][:course_id]
        topic[:section_id] = params[:post][:section_id] 
        topic[:topic_id] = params[:post][:topic_id] 
        @topic = SubTopic.new(topic)
        all_records << @topic
        is_all_valid << @topic.valid?
        @invalid_data << (!@topic.valid? ? @topic.sub_topic_name : "")
      end unless params[:sub_topic].blank?
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
        session[:topic_id] = params[:id] if params[:id]
        str =  session[:topic_id] ? " and topic_id = #{session[:topic_id]}" : ""        
        @sub_topics = SubTopic.joins([:topic,:section,:course]).where("(topics.is_deleted = false) and (sections.is_deleted = false) and (courses.is_deleted = false)"+str).page(params[:page]) unless (params[:commit] && (params[:commit].downcase=="filter"))
        format.html
        end
      end   

      def destroy
        SubTopic.find(params[:id]).update_attribute(:is_deleted,true)
        respond_to do |format|
          format.html { redirect_to admin_sub_topics_url }
        end
      end       
  end



  index do
    div :class=> "bread-nav" do
      navigation_add Course.where("id=?",session[:course_id]).first.course_name, :controller => "sections" if session[:course_id] 
      navigation_add Section.where("id=?",session[:section_id]).first.section_name, :controller => "topics" if session[:section_id]
      navigation_add Topic.where("id=?",session[:topic_id]).first.topic_name, :controller => "sub_topics" if session[:topic_id]
       render_navigation
    end    
    column :sub_topic_name, :sortable => :sub_topic_name do |i|
     link_to  i.sub_topic_name, :controller=> "questions", :action => "index", :id => i.id
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
    column "Topic name", :topic_id do |t|
      if !t.blank? && !t.topic.blank?
        t.topic.topic_name
      else
        "blank"
      end  
    end     
    column "Subscription Type", :only_paid do |v|
      (v.only_paid==true) ? "Paid" : "Free"
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
        if !t.blank? && !t.section.blank?
          t.section.course.course_name
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
      row "Topic name" do |t|
      if !t.blank? && !t.topic.blank?
        t.topic.topic_name
      else
        "blank"
      end  
    end  
      row :sub_topic_name
      row :description do
        div do
          simple_format sub_topic.description
        end
      end
      row 'Section subscription type' do |v|
        (v.only_paid==0) ? "Free" : "Paid"
      end
      row :video_link
      row :max_q_level      
    end
  end    
end
