class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :body
      t.references :incident_report
      t.references :author

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
