class AddIncidentReportIdToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :incident_report_id, :integer
  end

  def self.down
    remove_column :images, :incident_report_id
  end
end
