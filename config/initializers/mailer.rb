ActionMailer::Base.default_url_options[:host] = configatron.host

ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => "587",  
  :domain               => "#{configatron.app_domain}",  
  :user_name            => "#{configatron.app_subscribe_user}",  
  :password             => "#{configatron.app_subscribe_password}",  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}