class AddAccessTokenToUserIdentity < ActiveRecord::Migration
  def self.up
    add_column :user_identities, :access_token, :string
  end

  def self.down
    remove_column :user_identities, :access_token
  end
end
