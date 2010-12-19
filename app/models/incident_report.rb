class IncidentReport < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  has_one :image, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  validates_presence_of :latitude, :longitude, :description, :author, :image
  validates_numericality_of :latitude, :longitude
  validates_length_of :description, :maximum => 255

  has_many :incident_reports_users, :dependent => :destroy
  has_many :dislikers, :class_name => 'User', :through => :incident_reports_users, :conditions => ["type = ?", "dislike"], :source => :user
  has_many :no_problemers, :class_name => 'User', :through => :incident_reports_users, :conditions => ["type = ?", "not_a_problem"], :source => :user
  
  # use geometrical distance
  named_scope :near, lambda {
                |longitude, latitude, limit|
                  where("abs(longitude - ?)*abs(longitude - ?) + abs(latitude - ?)*abs(latitude-?)",
                        longitude, longitude, latitude, latitude).limit(limit)
              }

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
