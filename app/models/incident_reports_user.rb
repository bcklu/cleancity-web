class IncidentReportsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :incident_report

  validates_presence_of :type
  validates_inclusion_of :type, :in => ["not_a_problem", "dislike", "resolved"]

  after_save :change_state

  def self.inheritance_column
    nil
  end
  
  def change_state
    return unless ["resolved", "not_a_problem"].include?(self.type)
    
    count = self.incident_report.incident_reports_users.where(:type => self.type).count
    
    if count > 3
      case self.type
      when "resolved"
        self.incident_report.solve!
      when "not_a_problem"
        self.incident_report.mark_not_a_problem!
      else
        raise self.inspect
      end
    end
  end
end
