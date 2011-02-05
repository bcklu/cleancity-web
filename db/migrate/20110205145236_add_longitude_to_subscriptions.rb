class AddLongitudeToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :longitude, :float
  end

  def self.down
    remove_column :subscriptions, :longitude
  end
end
