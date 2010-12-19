Rails3Base::Application.routes.draw do
  devise_for :users,
      :controllers => {:omniauth_callbacks => 'omniauth_callbacks'}

  as :user do
    get 'login', :to => 'devise/sessions#new', :as => 'new_user_session'
    get 'logout', :to => 'devise/sessions#destroy', :as => 'destroy_user_session'
    get 'signup', :to => 'devise/registrations#new', :as => 'new_user_registration'
  end

  root :to => redirect{|p, req| "http://schandflecken.wordpress.com" }

  match "/" => redirect{|p, req| "http://schandflecken.wordpress.com" }

  resources :incident_reports do
    member do
      get 'dislike'
      get 'not_a_problem'
      get 'resolve'
    end

    resources :incident_report_comments
  end

  # static pages
  match "/agb" => "misc#agb"
  match "/faq" => "misc#faq"

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
