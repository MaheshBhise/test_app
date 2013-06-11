class Section < ActiveRecord::Base
  belongs_to :course
  has_many :topics
  has_many :sub_topics, :through => :topics
  has_many :questions, :through => :sub_topics

  attr_accessible :course_id, :description, :max_q_level, :only_paid, :section_name, :video_link
  
  validates_presence_of :section_name, :message => "Please enter section name."  
  validates_uniqueness_of :section_name, :scope => :course_id, :message => "This Section already exists!" 
  
  validates_presence_of :course_id, :message => "Please select any course."

  # attr_accessible :title, :body


      def page_title
       	self.section_name
      end

      def display_name
    	"#{self.section_name}"
  	  end  
end
