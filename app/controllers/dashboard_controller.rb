class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :filter_resource_access, :except => [:index, :show]

  def index
  end
end
