class Admin::IncidentReportsController < ApplicationController
  inherit_resources

  before_filter :authenticate_user!
  
  filter_resource_access

  protected

  def collection
    @admin_incident_reports ||= end_of_association_chain.paginate(:page => params[:page])
  end
end
