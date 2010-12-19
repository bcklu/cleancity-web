class MiscController < ApplicationController
  def agb
    render :template => 'static/agb', :layout => true
  end

  def faq
    render :template => 'static/faq', :layout => true
  end
end
