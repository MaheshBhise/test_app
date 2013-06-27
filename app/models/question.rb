class Question < ActiveRecord::Base
  belongs_to :course
  belongs_to :section
  belongs_to :topic  
  belongs_to :sub_topic
  belongs_to :admin_user
  #has_one :image, :as => :imageable, :dependent => :destroy
  #accepts_nested_attributes_for :image
  attr_accessible :correct_answer, :difficulty_level, :fake_answer1, :fake_answer2, :fake_answer3, :fake_answer4, :hint1, :hint2, :hint3, :image_link, :long_explain, :only_paid, :question, :section_id, :topic_id,:course_id, :video_link, :sub_topic_id, :admin_user_id
  validates_presence_of :question, :message => "Please enter a Question."    
  validates_presence_of :section_id, :message => "Please select section name."    
  validates_presence_of :course_id, :message => "Please select course name."
  validates_presence_of :sub_topic_id, :message => "Please select Sub Topic name."  
  validates_presence_of :topic_id, :message => "Please select topic name."   
  validates_presence_of :difficulty_level, :message => "Please assign difficulty level"
  validates_presence_of :correct_answer, :message => "Please enter correct answer for the question."
  validates_presence_of :fake_answer4
  validates_presence_of :fake_answer3
  validates_presence_of :fake_answer2
  validates_presence_of :fake_answer1
      def display_name
      "#{self.id}"
      end   
  
  def self.get_next_question(que_arr,level,increment_level)
    question = self.where("id NOT IN (?) and difficulty_level = (?)",que_arr,level).first
    if question.nil?
      if increment_level
        q_level = (level + 1)
         while q_level
           q_level = (q_level == 8) ? (q_level = 0) : q_level
           question = self.where("id NOT IN (?) and difficulty_level = (?)",que_arr,q_level).first
           break if !question.nil? || (q_level == level)
           q_level += 1
         end
      else
        q_level = (level - 1)
         while q_level 
           q_level = (q_level == 0) ? (q_level = 7) : q_level
           question = self.where("id NOT IN (?) and difficulty_level = (?)",que_arr,q_level).first
           break if !question.nil? || (q_level == level)
           q_level -= 1
         end
      end
    end
    question
  end

end
