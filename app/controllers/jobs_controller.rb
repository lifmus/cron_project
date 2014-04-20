class JobsController < ActionController::Base

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

end