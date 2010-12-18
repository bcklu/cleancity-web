class Comment < ActiveRecord::Base
  belongs_to :incident_report
  belongs_to :author, :class_name => 'User'
end
