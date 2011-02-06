module IncidentReportHelper
  def prepare_markers(incident_reports)
    result  = "["
    incident_reports.each do |report|
      
      if incident_reports.first != report
        result += ", "
      end
      
      if !report.latitude.nil? && !report.longitude.nil?
        result += "{ 'lat':#{report.latitude}, 'long':#{report.longitude}, 'description':'#{report.description}'}"
      end
    end
    
    result += "]"
  end
end