class IncidentReport < ActiveRecord::Base
  include AASM

  attr_accessor :facebook
  
  belongs_to :author, :class_name => 'User'
  has_one :image, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  validates_presence_of :author, :image
  validates_numericality_of :latitude, :allow_nil => true
  validates_numericality_of :longitude, :allow_nil => true
  validates_length_of :description, :maximum => 255
  
  after_create :deliver_new_incident_notification
  
  has_many :incident_reports_users, :dependent => :destroy
  has_many :dislikers, :class_name => 'User', :through => :incident_reports_users, :conditions => ["type = ?", "dislike"], :source => :user
  has_many :no_problemers, :class_name => 'User', :through => :incident_reports_users, :conditions => ["type = ?", "not_a_problem"], :source => :user
  has_many :resolvers, :class_name => 'User', :through => :incident_reports_users, :conditions => ["type = ?", "resolved"], :source => :user
  
  # use geometrical distance
  scope :incidents_within, lambda {
                |longitude, latitude, range_x, range_y, limit|
                  where("longitude between ? and ? and latitude between ? and ?",
                        longitude - range_x, longitude + range_x, latitude - range_y, latitude + range_y).limit(limit)
              }
              
  scope :solved, where("aasm_state = ?", 'solved')
  scope :published, where("aasm_state = ?", 'published')
  scope :latest, lambda { |count| order("created_at DESC").limit(count) }

  aasm_initial_state :published

  aasm_state :published
  aasm_state :not_a_problem
  aasm_state :solved

  aasm_event :solve do
    transitions :to => :solved, :from => [:published, :not_a_problem]
  end
  
  aasm_event :mark_as_not_a_problem do
    transitions :to => :not_a_problem, :from => [:published]
  end
  
  def next
    IncidentReport.where("created_at > ?", created_at).limit(1).order("created_at ASC").first
  end
  
  def previous
    IncidentReport.where("created_at < ?", created_at).limit(1).order("created_at DESC").first
  end
  
  def deliver_new_incident_notification
    Subscription.within(self.longitude, self.latitude).each do |subscription|
      SubscriptionMailer.new_incident(self, subscription).deliver
    end
  end
  
  def location_valid?
    latitude && longitude && latitude > 0.0 && longitude > 0.0
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
  
  def upload_to_facebook(current_user, incident_url)
    if Rails.env == 'production'
      picture_url = "http://#{configatron.host}/#{self.image.image.url}"
    else
      picture_url = "http://schandflecken.files.wordpress.com/2010/12/2010-12-18-schandfleck-logo_wb_v1_940x198.png"
      incident_url = "http://schandfleck.in"
    end
    current_user.facebook.feed!(
      :message => 'Neuer Schandfleck in meiner Umgebung.',
      :picture => picture_url,
      :link => incident_url,
      :name => "Schandfleck at #{latitude} / #{longitude}",
      :description => description
    )
  end
  
end
