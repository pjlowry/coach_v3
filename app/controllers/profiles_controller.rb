class ProfilesController < ApplicationController

  load_and_authorize_resource  


  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(params[:profile])
    if @profile.save
      @profile = Faraday.post do |request|
        request.url "https://api:key-3uwo2l351uy1ya54t0kucv69n430v859@api.mailgun.net/v2/coachatlas.mailgun.org/messages"
        request.headers['Content-Type'] = "application/x-www-form-urlencoded"
        request.headers['Authorization'] = "Basic " + Base64.strict_encode64("api:key-3uwo2l351uy1ya54t0kucv69n430v859")
        request.body = URI.encode_www_form({ 
                      :from => "support@coachatlas.com",
                      :to => @profile.contact_email,
                      :subject => "Welcome to CoachAtlas",
                      :text => "Welcome to CoachAtlas.com, <%= @profile.first_name %>
                                ===============================================
                                 
                                You have successfully signed up to CoachAtlas.com.
                                 
                                To view your profile, just visit coachatlas.com/profiles/<%= @profile.id %>
                                 
                                Thanks for joining, we hope you enjoy CoachAtlas!
                                -Team CoachAtlas"})
      end

      redirect_to profile_path(@profile.id)
      flash[:notice] = "Your profile has been created."
    else
      render new_profile_path
      flash[:alert] = "You missed a section."
    end
  end

  def index
    if params[:query].present? && params[:search].present? && params[:distance_search].present? 
      @profiles = Profile.text_search(params[:query]).near(params[:search], params[:distance_search], :order => :distance).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif params[:query].present? && params[:search].present?
      @profiles = Profile.text_search(params[:query]).near(params[:search], 50, :order => :distance).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif params[:query].present? && params[:distance_search].present?
      @profiles = Profile.text_search(params[:query])
    elsif params[:search].present? && params[:distance_search].present?
      @profiles= Profile.near(params[:search], params[:distance_search], :order => :distance).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif params[:distance_search].present?
      @profiles = Profile.near((request.ip), params[:distance_search], :order => :distance).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif params[:query].present?
      @profiles = Profile.text_search(params[:query]).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif params[:search].present?
      @profiles = Profile.near(params[:search], 50, :order => :distance).sorted(params[:sort], "created_at DESC").page(params[:page])
    else
      @profiles = Profile.sorted(params[:sort], "created_at DESC").page(params[:page]) 
    end
    if @profiles.count == 0
      flash[:alert] = "Sorry we couldn't find any coaches for you."
      @profiles = Profile.sorted(params[:sort], "created_at DESC").page(params[:page])

    end
    @json = @profiles.to_gmaps4rails do |profile, marker|
     marker.infowindow render_to_string(:partial => "/profiles/infowindow", :locals => {:profile => profile})
       marker.title "Coach #{profile.first_name} #{profile.last_name[0]}" 
       marker.picture({:picture => "/images/gmap-image.png", :width => 30,
                    :height => 30})  
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