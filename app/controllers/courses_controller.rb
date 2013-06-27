class CoursesController < ApplicationController
before_filter :authenticate_user!, :only=>[:take_diagnostic,:exam_intro,:join_course,:start_exam,:my_courses]

def course_info
	@course = Course.find_by_id(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @course }
    end
end

def join_course
	UserCourse.create(:course_id => params[:id], :user_id => current_user.id)
  redirect_to :action => 'my_courses'
end

def get_all_sections
	@course = Course.find_by_id(params[:id])
end

def exam_intro
  @exam   = Exam.where("id = ? and lower(test_name) like '%diagnostic%' ", params[:id]).first
  @exam   = Exam.where("id = ?", params[:id]).first if @exam.nil?
  session[:exam_id] = @exam.id
end

def take_diagnostic
  current_user.initialize_exam(session[:exam_id])
  @exam_time = UserExamSession.where(:user_id => current_user.id, :exam_id => session[:exam_id]).first.time_remaining
	get_question
end

def get_question
     user_exam_data = UserExamData.where(:user_id => current_user.id, :exam_id => session[:exam_id]).first
     section_ids = user_exam_data.attempted_questions
     solved_questions = user_exam_data.exam_results.map(&:question_id)
     @section_id_array = []
     @question_count = 0
     section_ids.each do |key,value|
       @section_id_array << key if value != 0
       @question_count = @question_count + value
     end
     if solved_questions.blank?
       @question = Question.where("section_id = ?", @section_id_array.sample).first
     else
       @question = Question.where("section_id = ? and id not in (?)", @section_id_array.sample, solved_questions).first
     end
     collect_shuffled_options(@question)
end

def next_question
	@current_que = Question.find_by_id(params[:que_id])
  user_exam_data = UserExamData.where(:user_id => current_user.id, :exam_id => session[:exam_id]).first
	if(@current_que.correct_answer == params[:selected_answer])
    user_exam_data.update_exam_data(true,params[:que_id])
	else
    user_exam_data.update_exam_data(false,params[:que_id])
	end
  get_question
	respond_to do |format|
       format.js {  }
    end
end

def collect_shuffled_options(que)
	@options = []
	@options << que.fake_answer1
	@options << que.fake_answer2
	@options << que.fake_answer3
	@options << que.fake_answer4
	@options << que.correct_answer
	@options.shuffle
end

def log_exam_session
   user_session = UserExamSession.where(:user_id => current_user.id, :exam_id => session[:exam_id]).first
   if user_session.time_remaining != 0
   time = user_session.time_remaining - 10
   user_session.update_attributes(:time_remaining => time)
   end
   render :text => ""
end

def time_up
  render :js => "window.location = '/courses/test_result'"
end

def show_section
  @courses = Course.where('is_deleted = ?',false)
  @partial_to_load = params[:id]
	respond_to do |format|
       format.js {  }
  end
end

def my_courses
  @courses = current_user.courses
end

def view_all
  @registered_courses_by_current_user = UserCourse.select("course_id").where("user_id=?",current_user.id).pluck("course_id")
  @courses = @registered_courses_by_current_user.blank? ? Course.all : Course.where("id not in (?)",@registered_courses_by_current_user)
end

def set_current_course_session
  session[:current_user_course_id] = Course.find_by_id(params[:id]).id unless params[:id].nil?
  if session[:current_user_course_id].nil?
    flash[:notice] = 'Please select a course.'
    redirect_to :back
  end
end

def lessons
  set_current_course_session
  @sub_topics = SubTopic.where("course_id =?", session[:current_user_course_id]) unless session[:current_user_course_id].nil?
end

def diagnostics
  set_current_course_session
  @exam = Exam.where("course_id = ? and only_paid = ?", session[:current_user_course_id], false ).first unless session[:current_user_course_id].nil?
end

def reassess
  set_current_course_session
  @exams = Exam.where("course_id = ? and only_paid = ?", session[:current_user_course_id], true ) unless session[:current_user_course_id].nil?
end

def show_subtopic_details
  @sub_topic = SubTopic.find(params[:id])
end

end
