class IncidentReport < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  has_one :image, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  validates_presence_of :latitude, :longitude, :description, :user, :image
  validates_numericality_of :latitude, :longitude
end
