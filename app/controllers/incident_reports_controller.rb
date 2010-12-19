require 'base64'

class IncidentReportsController < ApplicationController
  DEFAULT_SEARCH_LIMIT = 10

  def dislike
    ir = IncidentReport.find(params[:id])
    tmp = IncidentReportsUser.find_or_create_by_incident_report_id_and_user_id(ir.id, User.first.id)
    tmp.type = "dislike"
    tmp.save

    redirect_to incident_report_path(ir.id)
  end

  def not_a_problem
    ir = IncidentReport.find(params[:id])
    tmp = IncidentReportsUser.find_or_create_by_incident_report_id_and_user_id(ir.id, User.first.id)
    tmp.type = "not_a_problem"
    tmp.save

    redirect_to incident_report_path(ir.id)
  end

  def resolve
    ir = IncidentReport.find(params[:id])
    tmp = IncidentReportsUser.find_or_create_by_incident_report_id_and_user_id(ir.id, User.first.id)
    tmp.type = "resolved"
    tmp.save

    redirect_to incident_report_path(ir.id)
  end

  def create
    # accept either user or author
    user = find_user(params[:user].blank? ? params[:author] : params[:user])

    # temporary create the incident report
    # TODO: move this into virtual model method?
    p = params[:incident_report] || {}
    @incident_report = IncidentReport.new :latitude => p[:latitude],
                                          :longitude => p[:longitude],
                                          :description => p[:description],
                                          :author => user
    
    # store image data in a temporary file
    if p[:image].blank?
      render :status => 500, :text => "no image given"
      return
    elsif p[:image].is_a? ActionDispatch::Http::UploadedFile
      img = Image.new :image => p[:image],
                      :incident_report => @incident_report
      @incident_report.image = img
    else
      begin
        fp = File.open("/tmp/#{SecureRandom.hex(11)}.jpg", "wb+")
        size = fp.write Base64.decode64(p[:image])
        image = @incident_report.build_image :image => fp
        fp.close
      rescue
        render :status => 500, :text => "invalid image"
        return
      end
    end

    respond_to do |format|
      format.html do
        if @incident_report.save
          redirect_to @incident_report
        else
          render @incident_report
        end
      end
    end
  end

  def show
    @incident_report ||= IncidentReport.find(params[:id])
  end

  def new
    @current_object ||= IncidentReport.new
  end

  def index
    # allow searches to be geographically scoped
    
    params[:limit] ||= DEFAULT_SEARCH_LIMIT
    
    if params.include?(:longitude) && params.include?(:latitude) && params.include?(:range_x) && params.include?(:range_y)
      @incident_reports ||= IncidentReport.incidents_within(params[:longitude].to_f,
                                                            params[:latitude].to_f,
                                                            params[:range_x].to_i,
                                                            params[:range_y].to_i,
                                                            params[:limit].to_i)
    else
      @incident_reports ||= IncidentReport.all
    end
    
    respond_to do |format|
      format.html
    end
  end

  def edit
    @incident_report ||= IncidentReport.find(params[:id])
  end

  protected

  # create user (currently shortcut)
  def find_user(username)
    user = User.find_or_create_by_full_name(params[:user])
    user.password = user.password_confirmation = params[:user]

    user
  end
end
