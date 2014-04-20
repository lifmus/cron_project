class Output < ActiveRecord::Base

  belongs_to :job

  scope :successful,   -> { where(success: true) }
  scope :unsuccessful, -> { where(success: false) }

  def latest_run_datetime
    self.created_at.localtime.strftime("%m/%d/%Y %I:%M %p")
  end

end