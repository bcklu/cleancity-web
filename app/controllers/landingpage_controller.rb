class LandingpageController < ApplicationController 
  def index
    @latest_incident_reports = IncidentReport.published.latest(3)
    @solved_incident_reports = IncidentReport.solved.latest(3)
  end
end
