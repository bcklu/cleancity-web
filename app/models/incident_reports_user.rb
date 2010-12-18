class IncidentReportsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :incident_report

  validates_presence_of :type

  def self.inheritance_column
    nil
  end
end
