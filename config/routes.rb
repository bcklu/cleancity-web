Rails3Base::Application.routes.draw do
  devise_for :users,
      :controllers => {:omniauth_callbacks => 'omniauth_callbacks'}

  as :user do
    get 'login', :to => 'devise/sessions#new', :as => 'new_user_session'
    get 'logout', :to => 'devise/sessions#destroy', :as => 'destroy_user_session'
    get 'signup', :to => 'devise/registrations#new', :as => 'new_user_registration'
  end

#  root :to => redirect{|p, req| "http://schandflecken.wordpress.com" }
   root :to => "landingpage#index"
#  match "/" => redirect{|p, req| "http://schandflecken.wordpress.com" }

  resources :subscriptions do
     member do
       get 'confirm'
       get 'unsubscribe'
     end
   end

  resources :incident_reports do
    member do
      IncidentReportsController::STATES.each do |state|
        get state
      end
    end

    resources :comments, :controller => 'incident_report_comments'
  end

  # static pages
  match "/agb" => "misc#agb"
  match "/faq" => "misc#faq"
  match "/contributors" => "misc#contributors"  

  # API access
  scope '/1' do
    resources :incident_reports, :controller => 'api/incident_reports'
  end
  
  # TODO only allow access to admins
  namespace :admin do
    resources :incident_reports
    resources :users
  end
end
