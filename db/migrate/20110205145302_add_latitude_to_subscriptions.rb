class AddLatitudeToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :latitude, :float
  end

  def self.down
    remove_column :subscriptions, :latitude
  end
end
