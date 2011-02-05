class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.text :email
      t.text :secret
      t.text :aasm_state

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
