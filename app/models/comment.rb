class Comment < ActiveRecord::Base
  belongs_to :incident_report
  belongs_to :author, :class_name => 'User'
  
  validates_presence_of :body
  validates_length_of :body, :maximum => 255
end
