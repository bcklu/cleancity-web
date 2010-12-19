require 'base64'

class Api::IncidentReportsController < ApplicationController
  
  respond_to :json

  DEFAULT_SEARCH_LIMIT = 10

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
      format.json do
        if @incident_report.save
          render :status => 200, :json => @incident_report.id
        else
          render :status => 500, :json => @incident_report.errors.full_messages.join(",").to_json
        end
      end
    end
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
      format.json do
        # prepare result statement
        render :json => @incident_reports.map {|ir| { :latitude => ir.latitude,
                                                      :longitude => ir.longitude,
                                                      :description => ir.description,
                                                      :user => ir.author ? ir.author.full_name : "anonymous",
                                                      :image => ir.image ? ir.image.image.url : "none" }
        }
      end
    end
  end

  private

  # create user (currently shortcut)
  def find_user(username)
    user = User.find_or_create_by_full_name(params[:user])
    user.password = user.password_confirmation = params[:user]
    user
  end
end