class Exam < ActiveRecord::Base
	has_many :test_sections, :dependent => :destroy
	belongs_to :course

  validates_presence_of :test_name, :message => "Please enter test name." 
  validates_presence_of :course_id, :message => "Please select a course." 

  validates_uniqueness_of :test_name, :message => "This test already exists!" 

	accepts_nested_attributes_for :test_sections, :allow_destroy => true
    attr_accessible :only_paid, :test_name, :course_id , :test_sections_attributes

      def display_name
    	"#{self.test_name}"
  	  end

end
