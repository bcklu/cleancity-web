class SubscriptionsController < ApplicationController
  def create
    @subscription = Subscription.new params[:subscription]
    @subscription.secret = ActiveSupport::SecureRandom.hex(16)

    # i believe this is something that might be frowned upon
    respond_to do |format|
      if @subscription.save
        format.html { redirect_to incident_reports_path }
        format.js
      else
        raise @subscription.errors.full_messages.inspect
      end
    end
  end
  
  def new
    @subscription = Subscription.new
    @subscription.longitude = 14.30899
    @subscription.latitude = 46.62794
    @subscription.distance = 1000
  end
  
  def confirm
    subscription = Subscription.find_by_secret(params[:id])

    if subscription
      subscription.confirm!
    else
      raise subscription.inspect
    end
    
    # i believe this is something that might be frowned upon
    respond_to do |format|
      format.html
    end
  end
  
  def unsubscribe    
    @subscription = Subscription.find_by_secret(params[:id])

    if @subscription
      @subscription.destroy
    end
    
    # i believe this is something that might be frowned upon
    respond_to do |format|
      format.html
    end    
  end
end
