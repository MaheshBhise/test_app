class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible  :email, :password, :password_confirmation, :remember_me, 
    :name, :security_question_id, :security_answer, :user_type_id, :status_id, :provider, :uid,:confirmed_at
  # attr_accessible :title, :body

  def initialize_exam(exam_id)
    user_session = UserExamSession.where("user_id = ? and exam_id = ?", self.id, exam_id)
    if user_session.empty?
      exam = Exam.find(exam_id)
      time = exam.test_sections.sum(&:time_alloted).to_i
      UserExamSession.create(:user_id => self.id, :exam_id => exam_id, :time_remaining => time*60 )
    end
    user_data = UserExamData.where("user_id = ? and exam_id = ?", self.id, exam_id)
    if user_data.empty?
      UserExamData.create(:user_id => self.id, :exam_id => exam_id)
    end
  end

  def update_exam_data(exam_id, question_id, correct_answer)
    user_data = UserExamData.where("user_id = ? and exam_id = ?", self.id, exam_id).first
    questions = user_data.attempted_questions
    questions ||= {}
    questions[question_id] = correct_answer ? 1 : 0
    user_data.update_attributes(:attempted_questions => questions)
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.new(name:auth.extra.raw_info.name,
        provider:auth.provider,
        uid:auth.uid,
        email:auth.info.email,
        password:Devise.friendly_token[0,20]
      )
      user.skip_confirmation!
      user.save! 
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
