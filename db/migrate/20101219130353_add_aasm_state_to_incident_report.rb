class AddAasmStateToIncidentReport < ActiveRecord::Migration
  def self.up
    add_column :incident_reports, :aasm_state, :string
    IncidentReport.reset_column_information
    IncidentReport.update_all("aasm_state" => "published")
  end

  def self.down
    remove_column :incident_reports, :aasm_state
  end
end
