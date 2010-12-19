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
  named_scope :incidents_within, lambda {
                |longitude, latitude, range_x, range_y, limit|
                  where("longitude between ? and ? and latitude between ? and ?",
                        longitude - range_x, longitude + range_x, latitude - range_y, latitude + range_y).limit(limit)
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
  
  def user_name
    author.full_name if author
  end
  
  def user_name=(new_name)
    if self.author
      self.author.full_name = new_name
      self.athor.save
    else
      # TODO: we need user management..
      self.author = User.find_or_create_by_email("someemailaddress@somedomain.xxx")
      self.author.password = self.author.password_confirmation = "fubar again"
      self.author.full_name = new_name
      self.author.save!
    end
  end
end
