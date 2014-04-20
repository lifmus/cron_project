class JobsController < ApplicationController

  def index
    @jobs = Job.all
  end

  def create
    @job = Job.new(params[:job].permit(:script, :interval, :minute, :hour, 
                                       :day_of_month, :month, :day_of_week))
    if @job.save
      flash[:success] = "Job created"
    else
      flash[:error] = @job.errors.empty? ? "Error" : @job.errors.full_messages.to_sentence
    end
    redirect_to jobs_path
  end

  def show
    @job = Job.find(params[:id])
    @outputs = @job.outputs
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job].permit(:script, :interval, :minute, :hour, 
                                       :day_of_month, :month, :day_of_week))
      flash[:success] = "Job updated"
      redirect_to jobs_path
    else
      flash[:error] = @job.errors.empty? ? "Error" : @job.errors.full_messages.to_sentence
      redirect_to edit_job_path(@job)
    end
  end

  def destroy
    @job = Job.find(params[:id])
    if @job.destroy
      flash[:success] = 'Job deleted'
      redirect_to jobs_path
    else
      flash[:error] = @job.errors.empty? ? 'Error' : @job.errors.full_messages.to_sentence
    end
  end

end