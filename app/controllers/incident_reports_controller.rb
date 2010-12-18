require 'base64'

class IncidentReportsController < ApplicationController
  respond_to :json

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
    end

    begin
      fp = File.open("/tmp/#{SecureRandom.hex(11)}.jpg", "wb+")
      size = fp.write Base64.decode64(p[:image])
      image = @incident_report.build_image :image => fp
      fp.close
    rescue
      render :status => 500, :text => "invalid image"
      return
    end

    if @incident_report.save
      render :status => 200, :text => "".to_json
    else
      render :status => 500, :text => @incident_report.errors.full_messages.join(",").to_json
    end
  end

  def show
    @incident_report ||= IncidentReport.find(params[:id])
  end

  def new
    @current_object ||= IncidentReport.new
  end

  def index
    @incident_reports ||= IncidentReport.all
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
