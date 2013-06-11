class CoursesController < ApplicationController
before_filter :authenticate_user!, :only=>[:take_diagnostic,:exam_intro,:join_course,:start_exam]

def course_info
	@course = Course.find_by_id(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @course }
    end
end

def join_course		
	@course = Course.find_by_id(params[:id])	
end

def get_all_sections		
	@course = Course.find_by_id(params[:id])	
end

def exam_intro
  session[:exam_id] = params[:id]
  @exam   = Exam.where("course_id = ?", params[:id]).first
end

def take_diagnostic
  current_user.initialize_exam(session[:exam_id])
	@section = Section.find_by_id(session[:exam_id])
	session[:questions] = []
	get_first_ques(@section)
end

def get_first_ques(sec)
	session[:set_level] = 0 if session[:set_level].blank?
	session[:level] = 1 if session[:level].blank?
  @exam_time = UserExamSession.where(:user_id => current_user.id, :exam_id => session[:exam_id]).first.time_remaining
	@question = Course.get_first_question(sec,session[:level])
	session[:questions] << @question.id
	collect_shuffled_options(@question)
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

def next_question
	@current_que = Question.find_by_id(params[:que_id])	
	if(@current_que.correct_answer == params[:selected_answer])
		session[:set_level] += 1
		session[:level] += 1 if(session[:set_level] == 3)
		session[:questions] << @current_que.id
    current_user.update_exam_data(session[:exam_id], params[:que_id], true)
	else
		session[:set_level] = 0
		session[:level] -= 1 if(session[:level] != 1)
		session[:questions] << @current_que.id
    current_user.update_exam_data(session[:exam_id], params[:que_id], false)
	end
  @question = Question.get_next_question(session[:questions],session[:level])
	@options = collect_shuffled_options(@question) unless @question.blank?
	respond_to do |format|
       format.js {  }
    end
end	


def log_exam_session
   user_session = UserExamSession.where(:user_id => current_user.id, :exam_id => session[:exam_id]).first
   time = user_session.time_remaining - 10
   user_session.update_attributes(:time_remaining => time)
   render :text => ""
end

def show_section
  @courses = Course.where('is_deleted = ?',false)
  @partial_to_load = params[:id]
	respond_to do |format|
       format.js {  }
  end
end

end
