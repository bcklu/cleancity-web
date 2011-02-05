class SubscriptionMailer < ActionMailer::Base
  default :from => "Schandfleck.in <#{configatron.app_subscribe_user}>"
  
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
