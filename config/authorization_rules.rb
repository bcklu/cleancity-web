authorization do
  role :admin do
    # namespaces are handled strange by declarative_authorization "#{namespace}_#{controllername}".to_sym
    has_permission_on [:admin_incident_reports, :admin_users], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    
    has_permission_on [:incident_report_comments], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    
    # remove :edit, :update
    has_permission_on [:incident_reports], :to => [:index, :show, :new, :create, :destroy, :update_attribute_on_the_spot]
  end
  
  role :guest do
    has_permission_on [:incident_reports, :incident_report_comments], :to => [:index, :show]
    has_permission_on [:dashboard], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :user do
    includes :guest
    
    has_permission_on :incident_reports, :to => [:new, :create, :index, :show, :dislike, :not_a_problem, :resolve]
    
    # will be switched over to a resource-based theme later
    has_permission_on :comments, :to => [:edit, :update, :destroy] do
      if_attribute :author => is {user}
    end
    
    # :edit is needed for upload
    has_permission_on :incident_reports, :to => [:edit, :update, :destroy, :update_attribute_on_the_spot] do
      if_attribute :author => is {user}
    end
  end
  
  role :admin do
    includes :user
  end
end
