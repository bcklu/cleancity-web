require 'base64'
class IncidentReportsController < ApplicationController
  respond_to :json

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
    fp = Tempfile.new "image"
    size = fp.write(Base64.decode64(p[:image]))

    # create the image
    image = @incident_report.build_image :image => fp
    fp.close(true)

    if @incident_report.save
      render :status => 200, :text => "".to_json
    else
      render :status => 500, :text => @incident_report.errors.full_messages.join(",").to_json
    end
  end

  protected

  # create user (currently shortcut)
  def find_user(username)
    user = User.find_or_create_by_full_name(params[:user])
    user.password = user.password_confirmation = params[:user]

    user
  end

  def collection
    @incident_reports ||= end_of_association_chain.paginate(:page => params[:page])
  end
end
