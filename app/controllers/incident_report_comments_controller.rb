class IncidentReportCommentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    ir = IncidentReport.find(params[:incident_report_id])

    if ir
      comment = ir.comments.build params[:comment]
      comment.author = ir.author
      comment.save!
    else
      raise ir.inspect
    end

    redirect_to incident_report_path(ir)
  end
end
