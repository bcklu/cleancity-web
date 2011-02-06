SimpleNavigation::Configuration.run do |navigation|  
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|
    primary.dom_class = 'main'
    
    # currently the dashboard does nothing, but we might use it later on
    primary.item :landingpage, 'Startseite', root_path
    primary.item :incidents, 'Schandflecken', incident_reports_path
    primary.item :incident_report_new, 'Neuen Schandfleck erstellen', new_incident_report_path
    primary.item :subscriptions, 'Schandfleck-Abo', new_subscription_path
    
    primary.with_options(:if => Proc.new {current_user && current_user.admin?}) do |admin_user|
      # TODO: add an admin dashboard
          admin_user.item :admin, 'Admin', admin_incident_reports_path do |admin|
          admin.item :incidents, 'Incidents', admin_incident_reports_path
          admin.item :users, 'Users', admin_users_path
      end
    end
  end
end
