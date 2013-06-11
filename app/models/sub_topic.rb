class SubTopic < ActiveRecord::Base
  belongs_to :course
  belongs_to :section
  belongs_to :topic
  has_many :questions
  attr_accessible :course_id, :description, :max_q_level, :only_paid, :section_id, :sub_topic_name, :video_link,:topic_id
  validates_presence_of :sub_topic_name, :message => "Please enter Sub topic name."
  validates_uniqueness_of :sub_topic_name, :scope => [:course_id,:section_id,:topic_id], :message => "This Sub-Topic already exists!" 
  validates_presence_of :course_id, :message => "Please select any course."
  validates_presence_of :section_id, :message => "Please select any section."
  validates_presence_of :topic_id, :message => "Please select any topic."   
  # attr_accessible :title, :body

      def page_title
       	self.sub_topic_name
      end

      def display_name
    	"#{self.sub_topic_name}"
  	  end   
end
