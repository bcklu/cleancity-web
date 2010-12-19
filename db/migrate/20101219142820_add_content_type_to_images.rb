class AddContentTypeToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :content_type, :string
  end

  def self.down
    remove_column :images, :content_type
  end
end
