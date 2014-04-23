require "spec_helper"

describe Job do
  it "Updates the latest run after being run" do
    new_job = Job.create(interval: "hourly")
    new_job.run

    (Time.zone.now - new_job.latest_run).abs.should be < 1
  end

  it "Saves an output when it's run" do
    ruby_script = "'The hour is currently #{DateTime.now.hour}'"
    new_job = Job.create(interval: "hourly", script: ruby_script, script_type: "Ruby")
    new_job.run

    new_job.outputs.last.created_at.to_s.should eq(new_job.latest_run.to_s)
  end
end