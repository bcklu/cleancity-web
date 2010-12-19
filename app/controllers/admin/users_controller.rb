class Admin::UsersController < ApplicationController
  inherit_resources
  
  before_filter :authenticate_user!
  
  filter_resource_access

  protected
  
  def resource_class
    User
  end

  def collection
    @admin_users ||= end_of_association_chain.paginate(:page => params[:page])
  end
  
  def resource
    if params[:id].blank?
      @admin_user ||= User.new
    else
      @admin_user ||= User.find(params[:id])
    end
  end
end
