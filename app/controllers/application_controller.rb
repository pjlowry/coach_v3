class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotSaved, :with => :record_not_saved

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
private


  def record_not_saved
    flash[:alert] = "Record Not Saved, Do you already have a profile?"
    redirect_to root_path
  end

  def record_not_found
    flash[:alert] = "Record Not Found"
    redirect_to root_path
  end

end
