class MiscController < ApplicationController
  def agb
    render :template => 'static/agb', :layout => true
  end

  def faq
    render :template => 'static/faq', :layout => true
  end
  
  def contributors
    render :template => 'static/contributors', :layout => true
  end  
end
