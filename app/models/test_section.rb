class TestSection < ActiveRecord::Base
  belongs_to :exam 

  validates_presence_of :number_of_questions, :message => "Please enter number of questions." 
  validates_presence_of :section_id, :message => "Please select a section name." 
  validates_presence_of :time_alloted, :message => "Please enter alloted time." 

  attr_accessible :number_of_questions, :section_id, :exam_id, :time_alloted
end
