class Subscription < ActiveRecord::Base
  
  include AASM
  
  validates_presence_of :email, :secret
  
  aasm_initial_state :requested

  aasm_state :requested
  aasm_state :authenticated

  aasm_event :confirm do
    transitions :to => :authenticated, :from => :requested
  end
  
  scope :within, lambda {
                |longitude, latitude|
                  where("longitude between (? - (distance/2)/1000*0.157) and (? + (distance/2)/1000*0.157) and latitude between (? - (distance/2)/1000*0.157) and (?+(distance/2)/1000*0.157)",
                        longitude, longitude, latitude, latitude)
              }
  
  after_create :deliver_confirmation_request
  
  def deliver_confirmation_request
    SubscriptionMailer.confirmation_request(self).deliver
  end
end
