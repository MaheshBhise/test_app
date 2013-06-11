class Topic < ActiveRecord::Base
  belongs_to :course
  belongs_to :section
  has_many :sub_topics
  has_many :questions, :through => :sub_topics
  attr_accessible :course_id, :description, :max_q_level, :only_paid, :section_id, :topic_name, :video_link
  
  validates_presence_of :topic_name, :message => "Please enter topic name."
  validates_uniqueness_of :topic_name, :scope => [:course_id,:section_id], :message => "This Topic already exists!" 
  validates_presence_of :course_id, :message => "Please select any course."
  validates_presence_of :section_id, :message => "Please select any section."

   
  # attr_accessible :title, :body

      def page_title
       	self.topic_name
      end

      def display_name
    	"#{self.topic_name}"
  	  end   
end
