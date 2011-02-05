class AddDistanceToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :distance, :float
  end

  def self.down
    remove_column :subscriptions, :distance
  end
end
