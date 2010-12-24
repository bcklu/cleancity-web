SimpleNavigation::Configuration.run do |navigation|  
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|
    primary.dom_class = 'main'
    
    # currently the dashboard does nothing, but we might use it later on
    primary.item :landingpage, 'Startseite', root_path
    
    primary.with_options(:if => Proc.new {current_user && current_user.admin?}) do |admin_user|
      # TODO: add an admin dashboard
          admin_user.item :admin, 'Admin', admin_incident_reports_path do |admin|
          admin.item :incidents, 'Incidents', admin_incident_reports_path
          admin.item :users, 'Users', admin_users_path
      end
    end
    
    # primary navigation path: incidents
    primary.item :incidents, 'Incidents', incident_reports_path
  end
end
