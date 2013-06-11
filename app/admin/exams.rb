ActiveAdmin.register Exam do
  menu :priority => 8,:label => "Manage Exams"

  config.clear_sidebar_sections!

  member_action :get_sections_for_test, :method => :get do
    @sections = Section.where(:course_id=>params[:selected])
    @sel_id = params[:sel_id]
    respond_to do |format|
     format.js {  }
   end
 end

 member_action :popultate_select_section, :method => :get do
  @sections = Section.where(:course_id=>params[:selected])
  respond_to do |format|
   format.js {  }
 end
end

 # form :validate => true ,:html => {:multipart => true} do |f|                         
 #    f.inputs "Test Details" do 
 #      f.input :course_id, :as => :select, :collection => Course.all.map{|b| [b.course_name,b.id]}, :required => true, :include_blank => "Please Select"
 #      f.input :test_name, :required => true
 #      f.input :only_paid,:label=>"Select Test Type",:as=>:radio, :collection => {"Free"=>false, "Paid"=>true}  
 #      f.has_many :test_sections do |ts|
 #        ts.input :section_id ,:as => :select, :collection => Section.all.map{|b| [b.section_name,b.id]}, :required => true, :include_blank => "Please Select"
 #        ts.input :number_of_questions, :required => true
 #        ts.input :time_alloted, :required => true
 #     end  
 #   end                       
 #   f.actions                         
 # end 
  #form :validate => true do |f|          
   # render "form"                                        
  #end 
  form :partial => "form"

  show do |test|
    attributes_table do
      row :test_name
      row "Course Name" do |n|
        n.course.course_name
      end
      row 'Test subscription type' do |v|
        (v.only_paid==true) ? "Paid" : "Free"
      end
    end

    div :class => "panel" do  #div start
      h3 "Sections"
      if test.test_sections and test.test_sections.count > 0
        div :class => "panel_contents" do
          div :class => "attributes_table" do
            table do
              tr do
                th do
                  "Section Name"
                end
                th do
                  "Number of Questions"
                end
                th do
                  "Alloted time"
                end                
              end
              tbody do
                test.test_sections.each do |ts|
                  tr do
                    td do
                      Section.where("id = ?", ts.section_id).first.section_name
                    end
                    td do
                      ts.number_of_questions
                    end
                    td do
                      ts.time_alloted
                    end
                  end
                end
              end
            end
          end
        end
      else
        h3 "No sections available"
      end
    end # end div

  end  
end
