class JobsController < ApplicationController

  load_and_authorize_resource  

  def new
    @job = Job.new
  end

  def create
    @job = current_user.jobs.build(params[:job])
    if @job.save
      redirect_to job_path(@job.id)
      flash[:notice] = "Your job has been created."
    else
      render new_job_path
      flash[:alert] = "You missed a section."
    end
  end

  def index
    if params[:job_query].present? && params[:job_search].present? && params[:job_distance_search].present?
      @jobs = Job.text_search(params[:job_query]).near(params[:job_search], params[:job_distance_search], :order => :distance).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif params[:job_query].present? && params[:job_search].present? 
      @jobs = Job.text_search(params[:job_query]).near(params[:job_search], 50, :order => :distance).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif params[:job_query].present? && params[:job_distance_search].present?
      render :index
      flash[:alert] = "Please enter a valid address or zip code to search for jobs."
    elsif params[:job_distance_search].present?
      render :index
      flash[:alert] = "Please enter a valid address or zip code to search for jobs." 
    elsif params[:job_query].present?
      @jobs = Job.text_search(params[:job_query]).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif params[:job_search].present?
      @jobs = Job.near(params[:job_search], 50, :order => :distance).sorted(params[:sort], "created_at DESC").page(params[:page])
    elsif
      @jobs = Job.sorted(params[:sort], "created_at DESC").page(params[:page])
    end
    if @jobs.count == 0
      flash[:alert] = "Sorry we couldn't find any jobs that fit that description"
      @jobs = Job.sorted(params[:sort], "created_at DESC").page(params[:page])
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def edit
    @job = Job.find(params[:id])

  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:notice] = "Your job was successsfully updated."
      redirect_to job_path(@job.id)
    else
      render :edit
      flash[:alert] = "You missed a section."
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    flash[:notice] = "Your job was successfully deleted."
    redirect_to root_path
  end

end
