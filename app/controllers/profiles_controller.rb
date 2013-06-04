class ProfilesController < ApplicationController

  load_and_authorize_resource  


  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(params[:profile])
    if @profile.save
      redirect_to profile_path(@profile.id)
      flash[:notice] = "Your profile has been created."
    else
      render new_profile_path
      flash[:alert] = "You missed a section."
    end
  end

  def index
    if params[:query].present? && params[:search].present? && params[:distance_search].present?
      @profiles = Profile.text_search(params[:query]) && Profile.near(params[:search], params[:distance_search], :order => :distance)
    elsif params[:query].present? && params[:search].present?
      @profiles = Profile.text_search(params[:query]) && Profile.near(params[:search], 50, :order => :distance)
    elsif params[:query].present? && params[:distance_search].present?
      render :index
    elsif params[:distance_search].present?
      @profiles = Profile.near((request.ip), params[:distance_search], :order => :distance)
    elsif params[:query].present?
      @profiles = Profile.text_search(params[:query])
    elsif params[:search].present?
      @profiles = Profile.near(params[:search], 50, :order => :distance)
    else
      @profiles = Profile.all 
    end
  end
  

  def show
    if params[:id].nil?
      flash[:alert] = "Sorry we couldn't find your profile"
      redirect_to root_path
    else
      @profile = Profile.find(params[:id])  
    end
  end

  def edit
    @profile = Profile.find(params[:id])

  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Your profile was successsfully updated."
      redirect_to profile_path(@profile.id)
    else
      render :edit
      flash[:alert] = "You missed a section."
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    flash[:notice] = "Your profile was successfully deleted."
    redirect_to root_path
  end
end