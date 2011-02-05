class Subscription < ActiveRecord::Base
  
  include AASM
  
  validates_presence_of :email, :secret
  
  aasm_initial_state :requested

  aasm_state :requested
  aasm_state :authenticated

  aasm_event :confirm do
    transitions :to => :authenticated, :from => :requested
  end
  
  after_create :deliver_confirmation_request
  
  def deliver_confirmation_request
    SubscriptionMailer.confirmation_request(self).deliver
  end
end
