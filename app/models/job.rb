class Job < ActiveRecord::Base
  include JobsHelper

  has_many :outputs, dependent: :destroy 

  validate :script_is_valid, on: [:create, :update], :if => :script_changed?

  STRING_TIME_EQUIVALENT     = { "minutely" => 1.minute, "15minutely" => 15.minutes, "hourly" => 1.hour, 
                                 "daily" => 1.day, "weekly" => 1.week, "monthly" => 1.month }

  INTERVAL_METHOD_EQUIVALENT = { "minute" => "minute", "hour" => "hour", "day_of_month" => "day", 
                                 "month" => "month", "day_of_week" => "wday" }                                  

  def self.qualifying_jobs
    self.is_active.meets_minute_criteria.meets_hour_criteria.meets_day_of_month_criteria.meets_month_criteria.meets_day_of_week_criteria
  end

  def self.is_active
    self.where(activated: true)
  end

  INTERVAL_METHOD_EQUIVALENT.keys.each do |interval|
    define_singleton_method("meets_#{interval}_criteria") do
      custom_sql_string = '(' + interval +' IS NULL) OR (' + interval  + ' = ' + DateTime.now.send(INTERVAL_METHOD_EQUIVALENT[interval]).to_s + ')'
      self.where(custom_sql_string)
    end
  end

  def self.run_jobs
    Job.qualifying_jobs.run_new_jobs
    STRING_TIME_EQUIVALENT.keys.each{ |f| Job.qualifying_jobs.run_jobs_with_interval_of(f)}
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
