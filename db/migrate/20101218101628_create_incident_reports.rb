class CreateIncidentReports < ActiveRecord::Migration
  def self.up
    create_table :incident_reports do |t|
      t.float :latitude
      t.float :longitude
      t.string :description
      t.references :image
      t.references :author

      t.timestamps
    end
  end

  def self.down
    drop_table :incident_reports
  end
end
