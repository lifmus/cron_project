class Job < ActiveRecord::Base

  STRING_TIME_EQUIVALENT = { "minutely" => 1.minute, "15minutely" => 15.minutes, "hourly" => 1.hour, 
                             "daily" => 1.day, "weekly" => 1.week, "monthly" => 1.month }

  def self.active_jobs
    self.where(activated: true)
  end

  def self.run_jobs
    Job.active_jobs.run_new_jobs
    ["minutely", "15minutely", "hourly", "daily", "weekly", "monthly"].each{ |f| Job.active_jobs.run_jobs_with_interval_of(f)}
  end

  def run
    puts "*"*50
    puts "Currently running job #{self.id}"
    puts "*"*50
    update_latest_run
  end

  private

  def self.run_new_jobs
    unrun_jobs = Job.active_jobs.where(latest_run: nil)
    unrun_jobs.each{ |j| j.run}
  end

  def self.run_jobs_with_interval_of(interval)
    time_period = STRING_TIME_EQUIVALENT[interval]
    Job.active_jobs.where(interval: interval).where("latest_run < ?", DateTime.now - time_period).each{ |j| j.run}   
  end

  def update_latest_run
    self.latest_run = DateTime.now
    self.save
  end

end
