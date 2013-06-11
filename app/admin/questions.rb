ActiveAdmin.register Question do
  menu :priority => 7

    config.clear_sidebar_sections!

    member_action :populate_all_select, :method => :get do
     @distinct = params[:distinct]
     if (params[:distinct] == "question_course_id")
       @sections = Section.where(:course_id=>params[:selected])
     elsif (params[:distinct] == "question_section_id")
       @topics = Topic.where(:section_id=>params[:selected])
     else
       @sub_topics = SubTopic.where(:topic_id=>params[:selected])
     end
      respond_to do |format|
       format.js {  }
      end
    end


    member_action :restore_record, :method => :get do
      Question.find(params[:id]).update_attribute(:is_deleted,false)
      respond_to do |format|
       format.html { redirect_to admin_questions_url }
      end
    end


    controller do
      def index
        index! do |format|
        session[:sub_topic_id] = params[:id] if params[:id]
        str =  session[:sub_topic_id] ? " and sub_topic_id = #{session[:sub_topic_id]}" : ""            
        @questions = Question.joins([:sub_topic,:topic,:section,:course]).where("(sub_topics.is_deleted = false) and (topics.is_deleted = false) and (sections.is_deleted = false) and (courses.is_deleted = false)"+str).page(params[:page]) unless (params[:commit] && (params[:commit].downcase=="filter"))
        format.html
        end
      end   

      def destroy
        Question.find(params[:id]).update_attribute(:is_deleted,true)
        respond_to do |format|
          format.html { redirect_to admin_questions_url }
        end
      end   

    end

  form :validate => true do |f|          
    render "form"                                        
  end 

 index do
    div :class=> "bread-nav" do
      navigation_add Course.where("id=?",session[:course_id]).first.course_name, :controller => "sections" if session[:course_id] 
      navigation_add Section.where("id=?",session[:section_id]).first.section_name, :controller => "topics" if session[:section_id]
      navigation_add Topic.where("id=?",session[:topic_id]).first.topic_name, :controller => "sub_topics" if session[:topic_id]
      navigation_add SubTopic.where("id=?",session[:sub_topic_id]).first.sub_topic_name, :controller => "questions" if session[:sub_topic_id]
       render_navigation
    end 
      column "Course Name" do |t|
        if !t.blank? && !t.course.blank?
          t.course.course_name
        else
          "blank"
        end  
      end 
      column "Section Name" do |t|
        if !t.blank? && !t.section.blank? 
           t.section.section_name
        else
          "blank"
        end  
      end
      column "Topic Name" do |t|
        if !t.blank? && !t.topic.blank?
           t.topic.topic_name
        else
          "blank"
        end       
      end 
      column "Sub-Topic Name" do |t|
        if !t.blank? && !t.sub_topic.blank?
           t.sub_topic.sub_topic_name
        else
          "blank"
        end       
      end       
      column "Question" do |q|
        div do 
          simple_format q.question
        end
      end
      column 'Section subscription type' do |v|
        (v.only_paid==0) ? "Free" : "Paid"
      end      
      column :difficulty_level
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

 show do
    attributes_table do
      row "Course Name" do |t|
        if !t.blank? && !t.sub_topic.blank? && !t.sub_topic.topic.section.blank?
          t.sub_topic.topic.section.course.course_name
        else
          "blank"
        end  
      end 
      row "Section Name" do |t|
        if !t.blank? && !t.sub_topic.blank? && !t.sub_topic.topic.section.blank?
           t.sub_topic.topic.section.section_name
        else
          "blank"
        end  
      end
      row "Topic Name" do |t|
        if !t.blank? && !t.sub_topic.blank? && !t.sub_topic.topic.blank?
           t.sub_topic.topic.topic_name
        else
          "blank"
        end       
      end 
      row :question do 
        div do 
          simple_format question.question
        end
      end
      row :correct_answer do 
        div do 
          simple_format question.correct_answer
        end
      end
      row :fake_answer1 do 
        div do 
          simple_format question.fake_answer1
        end
      end
      row :fake_answer2 do 
        div do 
          simple_format question.fake_answer2
        end
      end
      row :fake_answer3 do 
        div do 
          simple_format question.fake_answer3
        end
      end
      row 'Section subscription type' do |v|
        (v.only_paid==0) ? "Free" : "Paid"
      end      
      row :difficulty_level   
      row :video_link
      row :image_link   
      row :long_explain do 
        div do 
          simple_format question.long_explain
        end
      end
      row :hint1 do 
        div do 
          simple_format question.hint1
        end
      end
      row :hint2 do 
        div do 
          simple_format question.hint2
        end
      end
      row :hint3 do 
        div do 
          simple_format question.hint3
        end
      end 
    end
  end 
end
