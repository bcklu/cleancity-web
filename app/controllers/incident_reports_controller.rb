require 'base64'
class IncidentReportsController < ApplicationController
  inherit_resources

  def create

    # create user (currently shortcut)
    user = User.find_or_create_by_full_name(params[:user])
    user.password = user.password_confirmation = params[:user]

    # temporary create the incident report
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

    create!
  end

  protected

  def collection
    @incident_reports ||= end_of_association_chain.paginate(:page => params[:page])
  end
end
