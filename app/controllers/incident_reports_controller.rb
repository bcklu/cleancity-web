require 'base64'

class IncidentReportsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :feed]
#  filter_resource_access
  filter_access_to :all
  
  DEFAULT_SEARCH_LIMIT = 10
  STATES = ["dislike", "not_a_problem", "resolve"]
  
  STATES.each do |state|
    send :define_method, state do
      @ir = IncidentReport.find(params[:id])
      tmp = IncidentReportsUser.find_or_create_by_incident_report_id_and_user_id(@ir.id, @current_user.id)
      tmp.type = state == "resolve" ? "resolved" : state
      tmp.save!

      respond_to do |format|
        format.html { redirect_to incident_report_path(@ir.id) }
        format.js
      end
    end
  end

  def create
    # accept either user or author
    user = find_user(params[:user].blank? ? params[:author] : params[:user])

    # temporary create the incident report
    # TODO: move this into virtual model method?
    p = params[:incident_report] || {}
    @incident_report = IncidentReport.new( :author => @current_user )
    
    # store image data in a temporary file
    if p[:image].blank?
      render :status => 500, :text => "no image given"
      return
    elsif p[:image].is_a? ActionDispatch::Http::UploadedFile      
      img = Image.new :image => p[:image],
                      :content_type => p[:image].content_type,
                      :incident_report => @incident_report
      @incident_report.image = img
    else
      begin
        fp = File.open("/tmp/#{SecureRandom.hex(11)}.jpg", "wb+")
        size = fp.write Base64.decode64(p[:image])
        image = @incident_report.build_image :image => fp,
                                             :content_type => "image/jpeg"
        fp.close
      rescue
        render :status => 500, :text => "invalid image"
        return
      end
    end

    respond_to do |format|
      format.html do
        if @incident_report.save!
          redirect_to [:edit, @incident_report]
        else
          render :action => 'new'
        end
      end
    end
  end

  def show
    @incident_report ||= IncidentReport.find(params[:id])
    
    respond_to do |format|
      format.html
      format.atom { render :layout => false }
      format.rss { redirect_to incident_reports_path(:format => :atom), :status => :moved_permanently }
    end
  end

  def new
    @incident_report ||= IncidentReport.new
  end

  def update
    @incident_report = IncidentReport.find(params[:id])
    if @incident_report.update_attributes(params[:incident_report])
      flash[:notice] = "Successfully updated incident report."
      redirect_to @incident_report
    else
      render :action => 'edit'
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
      format.html
      format.atom { render :layout => false }
      format.rss { redirect_to incident_reports_path(:format => :atom), :status => :moved_permanently }
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
