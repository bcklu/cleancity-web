class SubscriptionMailer < ActionMailer::Base
  default :from => "#{configatron.app_subscribe_user}@#{configatron.app_domain}"
  
  def confirmation_request(subscription)
    @email = subscription.email
    @secret = subscription.secret
        
    mail(:to => @email,
         :subject => "Your Personal Schandfleck")
  end
  
  def new_incident(incident, subscription)
    @email = subscription.email
    @secret = subscription.secret
    @incident = incident
        
    mail(:to => @email,
         :subject => "Neuer Schandfleck!")
  end
end
