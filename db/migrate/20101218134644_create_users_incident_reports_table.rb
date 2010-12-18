class CreateUsersIncidentReportsTable < ActiveRecord::Migration
  def self.up
    create_table :incident_reports_users, :id => false do |t|
      t.references :user
      t.references :incident_report
      t.string :type
    end
  end

  def self.down
    drop_table :incident_reports_users
  end
end
