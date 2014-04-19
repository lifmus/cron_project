require "spec_helper"

describe Job do
  it "Updates the latest run after being run" do
    new_job = Job.create(interval: "hourly")
    new_job.run

    (Time.zone.now - new_job.latest_run).abs.should be < 1
  end
end