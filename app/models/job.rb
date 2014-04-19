class Job < ActiveRecord::Base

  def self.run_new_jobs
    Job.where(latest_run: nil).each{ |j| j.run}
  end

  def self.check_jobs(frequency)
    case frequency
    when "minutely" #for test purposes
      time_period = 1.minute
    when "hourly"
      time_period = 1.hour
    when "daily"
      time_period = 1.day
    when "weekly"
      time_period = 1.week
    when "monthly"
      time_period = 1.month
    end

    Job.where(frequency: frequency).where("latest_run < ?", DateTime.now - time_period).each{ |j| j.run}
  end

  def run
    puts "*"*50
    puts "Currently running job #{self.id}"
    puts "*"*50
    update_latest_run
  end

  private

  def update_latest_run
    self.latest_run = DateTime.now
    self.save
  end

end
