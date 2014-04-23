class Job < ActiveRecord::Base
  include JobsHelper

  has_many :outputs 

  validate :script_is_valid, on: [:create, :update], :if => :script_changed?

  STRING_TIME_EQUIVALENT = { "minutely" => 1.minute, "15minutely" => 15.minutes, "hourly" => 1.hour, 
                             "daily" => 1.day, "weekly" => 1.week, "monthly" => 1.month }                    

  def self.qualifying_jobs
    self.is_active.meets_minute_critera.meets_hour_critera.meets_day_of_month_critera.meets_month_critera.meets_day_of_week_critera
  end

  def self.is_active
    self.where(activated: true)
  end

  def self.meets_minute_critera
    self.where('(minute IS NULL) OR (minute = ?)', DateTime.now.minute)
  end

  def self.meets_hour_critera
    self.where('(hour IS NULL) OR (hour = ?)', DateTime.now.hour)
  end

  def self.meets_day_of_month_critera
    self.where('(day_of_month IS NULL) OR (day_of_month = ?)', DateTime.now.day)
  end

  def self.meets_month_critera
    self.where('(month IS NULL) OR (month = ?)', DateTime.now.month)
  end

  def self.meets_day_of_week_critera
    self.where('(day_of_week IS NULL) OR (day_of_week = ?)', DateTime.now.wday)
  end

  def self.run_jobs
    Job.qualifying_jobs.run_new_jobs
    ["minutely", "15minutely", "hourly", "daily", "weekly", "monthly"].each{ |f| Job.qualifying_jobs.run_jobs_with_interval_of(f)}
  end

  def run
    current_time = DateTime.now
    begin
      self.outputs.create(text: check_and_evaluate_script_type, success: true, created_at: current_time)
    rescue
      self.outputs.create(success: false, created_at: current_time)
    end
    self.update_attributes(latest_run: current_time)
  end

  def latest_run_datetime
    self.latest_run ? self.latest_run.localtime.strftime("%m/%d/%Y %I:%M %p").to_s : "Never"
  end

  private

  def script_is_valid
    begin
      check_and_evaluate_script_type
    rescue
      errors.add(:script, "is not valid")
    end
  end

  def check_and_evaluate_script_type
    if self.script_type == "Ruby"
      eval(self.script)
    elsif self.script_type == "Bash"
      system(self.script)
    end
  end

  def self.run_new_jobs
    Job.qualifying_jobs.where(latest_run: nil).each{ |j| j.run}
  end

  def self.run_jobs_with_interval_of(interval)
    time_period = STRING_TIME_EQUIVALENT[interval]
    self.where(interval: interval).where("latest_run < ?", DateTime.now + 5.seconds - time_period).each{ |j| j.run}   
  end

end
