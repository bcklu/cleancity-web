class IncidentReport < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  has_one :image, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  validates_presence_of :latitude, :longitude, :description, :author, :image
  validates_numericality_of :latitude, :longitude

  has_many :incident_reports_users, :dependent => :destroy
  has_many :dislikers, :class_name => 'User', :through => :incident_reports_users, :conditions => ["type = ?", "dislike"], :source => :user
  has_many :no_problemers, :class_name => 'User', :through => :incident_reports_users, :conditions => ["type = ?", "not_a_problem"], :source => :user

  def lat
    latitude
  end

  def lng
    longitude
  end

  def location_valid?
    latitude > 0.0 && longitude > 0.0
  end
end
