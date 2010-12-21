class IncidentReportCommentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    ir = IncidentReport.find(params[:incident_report_id])

    if ir
      @comment = ir.comments.build params[:comment]
      @comment.author = ir.author
      @comment.save!
    else
      raise ir.inspect
    end
    
    @c = Comment.new :incident_report => ir,
                     :author => ir.author

    # i believe this is something that might be frowned upon
    respond_to do |format|
      format.html { redirect_to incident_report_path(ir) }
      format.js
    end
  end
end
