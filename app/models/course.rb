class Course < ActiveRecord::Base
  has_many :sections
  has_many :topics, :through => :sections
  has_many :sub_topics, :through => :topics
  has_many :questions, :through => :sub_topics
  has_many :exams

  attr_accessible :course_name, :description, :max_q_level, :only_paid, :video_link
  
  validates_presence_of :course_name, :message => "Please enter course name." 
  validates_uniqueness_of :course_name, :message => "This course already exists!" 
  # attr_accessible :title, :body

      def page_title
       	self.course_name
      end

   def display_name
    "#{self.course_name}"
  end

  def self.get_first_question(sec,level)
    sec.questions.where(:difficulty_level => level).first
  end
end
